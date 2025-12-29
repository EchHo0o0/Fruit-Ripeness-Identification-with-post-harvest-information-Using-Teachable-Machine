// lib/home/home_screen.dart (Refactored for Merged Game Card and Responsiveness)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:harvi/admin/adminscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home/app_localizations.dart'; // REQUIRED: Import your localization class

import '../book/homeculture.dart';
import 'anouncebyadmin.dart';
import '../scan/display.dart';
import '../scan/scann.dart';
import 'setting.dart';
import '../daily_rewards_screen.dart';
import '../coin_pocket_manager.dart';
import '../game/fruit_identification_game.dart';
import '../game/time_challenge_game.dart'; // Import still needed for game route reference

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _userCoins = 0;
  String _userName = 'User'; // Default name
  String _userRole = 'user'; // Variable to store user role (default to 'user')
  int _selectedIndex = -1;
  User? _currentUser;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _harviAnimationController;
  late Animation<double> _harviScaleAnimation;
  late AnimationController _contentAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserInfoAndCoins(); // Load info and check role

    _harviAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _harviScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _harviAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    _harviAnimationController.forward();

    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentAnimationController,
        curve: Curves.easeIn,
      ),
    );
    _contentAnimationController.forward();
  }

  @override
  void dispose() {
    _harviAnimationController.dispose();
    _contentAnimationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Check role and redirect to AdminScreen if the user is an admin
  void _checkAdminRedirection() {
    if (_userRole == 'admin') {
      // Use pushReplacement to navigate and prevent admin from navigating back to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => const AdminScreen()), // Navigates to AdminScreen
      );
    }
  }

  // Load name, coins, AND role from Firestore
  Future<void> _loadUserInfoAndCoins() async {
    // 1. Load Coins
    final latestCoins = await CoinPocketManager.getCoins(widget.userId);

    String? newName;
    String newRole = 'user'; // Default role

    // 2. Try loading name AND role from Firestore
    if (_currentUser != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .get();

        final firestoreName = userDoc.data()?['fullName'] as String?;
        final firestoreRole = userDoc.data()?['role'] as String?;

        if (firestoreName != null && firestoreName.isNotEmpty) {
          newName = firestoreName;
        }
        if (firestoreRole != null && firestoreRole.isNotEmpty) {
          newRole = firestoreRole;
        }
      } catch (e) {
        // ignore: avoid_print
        print("Error fetching user info from Firestore: $e");
      }
    }

    // 3. Fallback to SharedPreferences
    if (newName == null) {
      final prefs = await SharedPreferences.getInstance();
      newName = prefs.getString('fullName');
    }

    if (!mounted) return;

    setState(() {
      _userCoins = latestCoins; // Update coins here
      _userName = (newName != null && newName.isNotEmpty)
          ? newName.split(' ')[0]
          : 'User';
      _userRole = newRole; // Update role state
    });

    // 4. Immediately check and redirect after loading the role
    _checkAdminRedirection();
  }

  // Function to Stream Unread Count (Pure Firebase/Dart Solution)
  Stream<int> _unreadAnnouncementsStream() {
    final user = _currentUser;
    if (user == null) {
      return Stream.value(0);
    }

    final allAnnouncementsStream =
        FirebaseFirestore.instance.collection('announcements').snapshots();

    final dismissedIdsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dismissedAnnouncements')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());

    final controller = StreamController<int>();
    List<DocumentSnapshot>? latestAnnouncements;
    Set<String> latestDismissedIds = {};

    void _calculateAndEmit() {
      if (latestAnnouncements != null) {
        final unreadCount = latestAnnouncements!.where((doc) {
          return !latestDismissedIds.contains(doc.id);
        }).length;
        controller.add(unreadCount);
      }
    }

    final sub1 = allAnnouncementsStream.listen((snapshot) {
      latestAnnouncements = snapshot.docs;
      _calculateAndEmit();
    });

    final sub2 = dismissedIdsStream.listen((dismissedIds) {
      latestDismissedIds = dismissedIds;
      _calculateAndEmit();
    });

    controller.onCancel = () {
      sub1.cancel();
      sub2.cancel();
    };

    return controller.stream;
  }

  // --- Time-based greeting ---
  // The greeting word must be translated using the localization system
  String _getGreeting(AppLocalizations localizations) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return localizations.translate('good_morning');
    } else if (hour < 18) {
      return localizations.translate('good_afternoon');
    } else {
      return localizations.translate('good_evening');
    }
  }

  // --- Circular GIF Widget (unchanged) ---
  Widget _fruitGifWidget() {
    return Container(
      width: 70,
      height: 70,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/fruit.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.yard, size: 50, color: Colors.green.shade400);
          },
        ),
      ),
    );
  }

  // 🔥 NEW: Merged Game Card Widget (Full-width, single card)
  Widget _mergedGameCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    // Using a Card for a large, single box
    return Card(
      elevation: 8,
      margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bigger radius for big card
      ),
      child: Container(
        // Use Expanded and Padding for flexible sizing across devices
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withOpacity(0.4),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(25.0), // Large padding
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Game Icon (Made Big)
                  Icon(icon, color: Colors.white, size: 60),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title, // "Guess the fruit"
                          style: const TextStyle(
                            fontSize: 28, // Bigger title
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description, // The merged/repeated definition
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Daily Rewards Banner Widget (strings translated) ---
  Widget _dailyRewardsBanner({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withOpacity(0.4),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 48),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, // TRANSLATED STRING
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle, // TRANSLATED STRING
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Bottom Navigation Item (label translated) ---
  Widget _bottomNavItem(IconData icon, String labelKey, VoidCallback onPressed,
      {bool isSelected = false,
      required Color selectedColor,
      int badgeCount = 0,
      required AppLocalizations localizations}) {
    // FIX 1: Handle 'settings' localization to remove '!' if present in the translated string.
    String translatedLabel = localizations.translate(labelKey);
    if (labelKey == 'settings') {
      translatedLabel = translatedLabel.replaceAll('!', '');
    }

    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 60.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? selectedColor : Colors.white70,
                    size: isSelected ? 28 : 26,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -5,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                translatedLabel, // Use the corrected/translated label
                style: TextStyle(
                  color: isSelected ? selectedColor : Colors.white70,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      switch (index) {
        case 0:
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DisplayPage(userId: widget.userId)))
              .then((_) {
            setState(() => _selectedIndex = -1);
          });
          break;
        case 1:
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HorticultureScreen()))
              .then((_) {
            setState(() => _selectedIndex = -1);
          });
          break;
        case 2:
          setState(() => _selectedIndex = -1);
          break;
        case 3:
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const UserAnnouncementScreen())).then((_) {
            setState(() => _selectedIndex = -1);
          });
          break;
        case 4:
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()))
              .then((_) {
            setState(() => _selectedIndex = -1);
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // NO AppLocalizations.of(context)! here anymore.

    const double headerHeight = 120.0;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color cardColor = Theme.of(context).cardColor;
    // final Color onBackgroundColor = Theme.of(context).colorScheme.onBackground; // Moved inside Builder

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color headerFooterColor =
        isDarkMode ? Colors.grey[900]! : Theme.of(context).colorScheme.primary;
    final Color coinIconColor = Colors.amber.shade400;
    final Color bottomNavColor = headerFooterColor;

    // 💡 IMPORTANT: Prevent rendering the main content if the user is identified as admin
    if (_userRole == 'admin') {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      // START OF FIX: Use Builder to get a context that is guaranteed to find AppLocalizations
      body: Builder(
        builder: (innerContext) {
          final localizations = AppLocalizations.of(innerContext);
          final Color onBackgroundColor =
              Theme.of(innerContext).colorScheme.onBackground;

          // If localizations is still null (rare, but handles the crash case)
          if (localizations == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Background (Header)
                Container(
                  height: headerHeight,
                  decoration: BoxDecoration(
                    color: headerFooterColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 40.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _harviScaleAnimation,
                          child: const Text(
                            'HARVI',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.monetization_on,
                                  color: coinIconColor, size: 24),
                              const SizedBox(width: 5),
                              Text(
                                '\$$_userCoins',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // **CHANGE 1: Reduced space above the greeting card (to move it up)**
                const SizedBox(height: 10.0),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Greeting Card
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: cardColor,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // FIX 2: Use RichText for flexible greeting word and name placement/justification
                                        RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              // **CHANGE 2: Reduced font size from 20 to 18**
                                              fontSize: 18,
                                              color: onBackgroundColor,
                                              fontWeight: FontWeight
                                                  .w400, // Reduced to w400 for greeting word
                                              height:
                                                  1.2, // Ensure flexible line spacing
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${_getGreeting(localizations)}, ',
                                              ),
                                              TextSpan(
                                                text: '$_userName!',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold, // Name is bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          // 🔥 TRANSLATED MOTTO
                                          localizations.translate('home_motto'),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: onBackgroundColor
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  _fruitGifWidget(),
                                ],
                              ),
                            ),
                          ),
                          // 🔥 TRANSLATED DAILY REWARDS BANNER
                          _dailyRewardsBanner(
                            title:
                                localizations.translate('claim_daily_rewards'),
                            subtitle: localizations
                                .translate('daily_rewards_subtitle'),
                            icon: Icons.card_giftcard,
                            color: const Color(0xFFFF8F00),
                            onPressed: () => Navigator.push(
                              innerContext, // Use innerContext for navigation
                              MaterialPageRoute(
                                builder: (_) =>
                                    DailyRewardsScreen(userId: widget.userId),
                              ),
                            ).then((_) {
                              _loadUserInfoAndCoins();
                            }),
                          ),
                          const SizedBox(height: 30),

                          // 🔥 NEW: MERGED GAME CARD SECTION
                          _mergedGameCard(
                            // Title: "Guess the fruit"
                            title: localizations.translate('guess_the_fruit'),
                            // Description: "Same in the guess the fruit"
                            description: localizations
                                .translate('guess_the_fruit_subtitle'),
                            icon: Icons
                                .extension, // Using a generic game/puzzle icon
                            color: const Color(0xFF43A047), // Green color
                            // On tap: Navigate to the Fruit Identification Game
                            onPressed: () => Navigator.push(
                              innerContext, // Use innerContext for navigation
                              MaterialPageRoute(
                                builder: (_) => FruitIdentificationGame(
                                    userId: widget.userId),
                              ),
                            ).then((_) {
                              _loadUserInfoAndCoins();
                            }),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10,
        color: bottomNavColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // We'll use the original context and force unwrap since the app cannot
              // function without localization strings in the bottom nav.

              // 🔥 TRANSLATED BOTTOM NAV ITEM
              _bottomNavItem(
                  Icons.history, 'repository', () => _onItemTapped(0),
                  isSelected: _selectedIndex == 0,
                  selectedColor: secondaryColor,
                  localizations: AppLocalizations.of(context)!),
              // 🔥 TRANSLATED BOTTOM NAV ITEM
              _bottomNavItem(Icons.menu_book, 'guide', () => _onItemTapped(1),
                  isSelected: _selectedIndex == 1,
                  selectedColor: secondaryColor,
                  localizations: AppLocalizations.of(context)!),
              const SizedBox(width: 48),
              StreamBuilder<int>(
                stream: _unreadAnnouncementsStream(),
                initialData: 0,
                builder: (context, snapshot) {
                  final unreadCount = snapshot.data ?? 0;
                  // 🔥 TRANSLATED BOTTOM NAV ITEM
                  return _bottomNavItem(
                    Icons.campaign,
                    'announced',
                    () => _onItemTapped(3),
                    isSelected: _selectedIndex == 3,
                    selectedColor: secondaryColor,
                    badgeCount: unreadCount,
                    localizations: AppLocalizations.of(context)!,
                  );
                },
              ),
              // 🔥 TRANSLATED BOTTOM NAV ITEM (FIXED)
              _bottomNavItem(Icons.settings, 'settings', () => _onItemTapped(4),
                  isSelected: _selectedIndex == 4,
                  selectedColor: secondaryColor,
                  localizations: AppLocalizations.of(context)!),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Scann()),
        ).then((_) {
          setState(() => _selectedIndex = -1);
        }),
        shape: const CircleBorder(),
        backgroundColor: secondaryColor,
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
