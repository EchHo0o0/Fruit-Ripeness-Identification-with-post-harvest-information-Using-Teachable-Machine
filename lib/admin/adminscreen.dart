import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // Import provider

// Project-specific imports
import '../authentication/sign.dart';
import 'package:harvi/home/user_list_screen.dart';
import 'package:harvi/admin/adminsignup.dart';
import 'package:harvi/announce/announce.dart';
import 'package:harvi/home/setting.dart';
// 🌟 NEW: Language Imports
import 'package:harvi/home/language_provider.dart';
import '../home/app_localizations.dart'; // Ensure this path is correct

// --- Data Structure for Admin Actions ---
class _AdminAction {
  final IconData icon;
  // Change final String label; to final String labelKey;
  final String labelKey;
  final Widget Function()? pageBuilder;

  // Update constructor to take a key
  _AdminAction(this.icon, this.labelKey, this.pageBuilder);
}

// --- AdminScreen Widget ---
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _adminName = 'Admin';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ⚠️ NOTE: The adminActions list must be defined inside the build method
  // or a method called from build to ensure AppLocalizations is available,
  // OR, we can access the localized strings on the fly inside the GridView builder.
  // For simplicity and to keep the structure, we will update the constructor
  // of _AdminAction to take a String KEY, and resolve it in the build method.

  // Define the keys for actions list
  final List<_AdminAction> adminActions = [
    _AdminAction(
        Icons.people_alt_rounded, 'manage_users', () => const UserListScreen()),
    _AdminAction(Icons.admin_panel_settings_rounded, 'create_admin_account',
        () => const AdminsScreen()),
    _AdminAction(Icons.campaign_rounded, 'create_announcement',
        () => AdminAnnouncementScreen()),
    _AdminAction(
        Icons.settings_rounded, 'settings', () => const SettingsScreen()),
  ];

  @override
  void initState() {
    super.initState();
    _loadAdminInfo();
  }

  // --- Time-based greeting ---
  String _getGreetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'good_morning';
    } else if (hour < 18) {
      return 'good_afternoon';
    } else {
      return 'good_evening';
    }
  }

  // --- Load Admin's first name ---
  Future<void> _loadAdminInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final firstName = data?['firstName'] as String?;
        if (mounted) {
          setState(() {
            _adminName = (firstName != null && firstName.isNotEmpty)
                ? firstName
                : 'Admin';
          });
        }
      }
    }
  }

  // Function for fade transition
  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ));
  }

  // --- Widget for the styled greeting box ---
  Widget _buildGreetingBox(
      BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final cardColor = theme.cardColor;

    // Get localized greeting and subtext
    final greetingText = localizations.translate(_getGreetingKey());
    final subtext = localizations.translate('admin_welcome_subtext');

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // GIF Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/fruit.gif',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Greeting Text
                Text(
                  '$greetingText,', // Use localized greeting
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
                // Admin Name
                Text(
                  _adminName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Subtext
                Text(
                  subtext, // Use localized subtext
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 1. Get the AppLocalizations instance
    final localeProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations(localeProvider.locale);

    final appBarColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          localizations.translate('admin_dashboard_title'), // Localized title
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: appBarColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌟 Pass localizations instance to the greeting box
              _buildGreetingBox(context, localizations),
              const SizedBox(height: 30),

              // New Section Title for the Grid
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  localizations.translate(
                      'quick_actions_title'), // Localized section title
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ),

              // Main GridView
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: adminActions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final action = adminActions[index];
                  // 🌟 Resolve the localized label using the key
                  final localizedLabel =
                      localizations.translate(action.labelKey);

                  return _ActionCard(
                    icon: action.icon,
                    label: localizedLabel, // Pass the localized label
                    onTap: () {
                      if (action.pageBuilder != null) {
                        if (!mounted) return;
                        _navigateWithFade(context, action.pageBuilder!());
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- ActionCard Widget for Grid Items ---
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label; // This is now the localized string
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label, // This parameter remains String label
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onSurface;
    final splashColor = theme.colorScheme.primary.withOpacity(0.2);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: splashColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(height: 8),
              Text(
                label, // Display the localized label
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
