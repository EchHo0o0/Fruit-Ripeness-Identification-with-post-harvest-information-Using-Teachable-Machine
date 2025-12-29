import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Ensure this import matches your project structure
import '../home/app_localizations.dart';

class UserAnnouncementScreen extends StatefulWidget {
  const UserAnnouncementScreen({super.key});

  @override
  State<UserAnnouncementScreen> createState() => _UserAnnouncementScreenState();
}

class _UserAnnouncementScreenState extends State<UserAnnouncementScreen> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateSearchQuery);
  }

  @override
  void dispose() {
    _searchController.removeListener(_updateSearchQuery);
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  /// CRITICAL FIX: Marks the announcement as dismissed by the user.
  /// This record is used to filter the main announcement list.
  Future<void> _markAsDismissed(String announcementId) async {
    final loc = AppLocalizations.of(context)!;

    if (_currentUser == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.translate('login_to_dismiss_snack'))),
      );
      return;
    }

    try {
      // Set a record in the user's dismissed collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .collection('dismissedAnnouncements')
          .doc(announcementId)
          .set({'dismissedAt': FieldValue.serverTimestamp()});

      if (!mounted) return;
      // We don't show a snackbar here as the Dismissible widget provides visual feedback.
    } catch (e) {
      debugPrint('Error dismissing announcement: $e');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(loc
                .translate('failed_to_dismiss_snack_template')
                .replaceAll('%s', e.toString()))),
      );
    }
  }

  /// Helper function to build the Dismissible item with improved design
  Widget _buildAnnouncementItem(BuildContext context, DocumentSnapshot doc) {
    final loc = AppLocalizations.of(context)!;
    final data = doc.data() as Map<String, dynamic>?;

    // Check theme brightness for dynamic coloring
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define the "milky, not solid white" color as requested (Ghost White)
    final Color milkyWhite = const Color(0xFFF8F8FF);

    // 🔥 Use the milky color in light mode. In dark mode, revert to the
    // theme's card color to maintain text readability (white text on dark card).
    final Color cardColor =
        isDarkMode ? Theme.of(context).cardColor : milkyWhite;

    // 🔥 Use theme colors for card and text
    final Color textColor = Theme.of(context).colorScheme.onSurface;

    String formattedDate = loc.translate('no_timestamp_available');
    if (data != null && data['timestamp'] is Timestamp) {
      try {
        formattedDate = DateFormat('MMM d, yyyy • h:mm a')
            .format((data['timestamp'] as Timestamp).toDate());
      } catch (e) {
        debugPrint('Error formatting date in list: $e');
        formattedDate = loc.translate('invalid_date_format');
      }
    }

    // Prioritize 'title' field, then first line of 'message'.
    final titleText = (data?['title'] as String? ??
        (data?['message'] as String?)?.split('\n')?.first ??
        loc.translate('no_message'));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(doc.id), // Unique key for Dismissible
        direction: DismissDirection.endToStart, // Swipe right to left
        background: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.error,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // Icon color should be white for contrast on the error color
          child:
              const Icon(Icons.archive_outlined, color: Colors.white, size: 30),
        ),
        onDismissed: (direction) {
          // Immediately mark as dismissed in Firestore when the swipe completes
          _markAsDismissed(doc.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(loc.translate('announcement_dismissed_snack'))),
          );
        },
        child: Card(
          // Use the dynamic cardColor (milky white in light mode, theme in dark mode)
          color: cardColor,
          elevation: 4, // Higher elevation for better shadow
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Icon(Icons.campaign_outlined,
                color: Theme.of(context).colorScheme.primary),
            title: Text(
              titleText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                // Use theme text color (onSurface)
                color: textColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              formattedDate,
              // Use theme text color with opacity
              style: TextStyle(color: textColor.withOpacity(0.9), fontSize: 13),
            ),
            onTap: () => _showAnnouncementDialog(context, doc),
            trailing: Icon(Icons.arrow_forward_ios,
                size: 16, color: textColor.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }

  // Confirmation dialog for the button click
  Future<void> _showDismissConfirmationDialog(String announcementId) async {
    final loc = AppLocalizations.of(context)!;
    final Color textColor = Theme.of(context).colorScheme.onSurface;

    // Using a more prominent confirm dialog
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          // Set text color for title and content
          title: Text(loc.translate('dismiss_confirmation_title'),
              style: TextStyle(color: textColor)),
          content: Text(loc.translate('dismiss_confirmation_content'),
              style: TextStyle(color: textColor.withOpacity(0.8))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.translate('cancel'),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              child: Text(loc.translate('button_dismiss'),
                  // Text is white for high contrast on the red error button
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _markAsDismissed(announcementId);
    }
  }

  void _showAnnouncementDialog(BuildContext context, DocumentSnapshot doc) {
    final loc = AppLocalizations.of(context)!;

    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) return;

    String message =
        data['message'] as String? ?? loc.translate('no_message_available');

    String formattedDate = loc.translate('no_timestamp_available');
    if (data['timestamp'] is Timestamp) {
      try {
        formattedDate = DateFormat('MMM d, yyyy • h:mm a')
            .format((data['timestamp'] as Timestamp).toDate());
      } catch (e) {
        debugPrint('Error formatting date: $e');
      }
    }

    // 🔥 Use theme colors for the dialog
    final dialogBackgroundColor = Theme.of(context).colorScheme.surface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          loc.translate('announcement_details_title'),
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              // Announcement Message
              Text(
                message,
                style:
                    TextStyle(color: textColor.withOpacity(0.9), fontSize: 16),
              ),
              const SizedBox(height: 16),
              Divider(color: textColor.withOpacity(0.3)),
              const SizedBox(height: 8),
              // Date
              Text(
                formattedDate,
                style:
                    TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDismissConfirmationDialog(doc.id);
            },
            child: Text(
              loc.translate('button_dismiss_announcement'),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.translate('button_done'),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 🔥 Use onSurface for text that goes on the AppBar/Background
    final appBarTextColor = Theme.of(context).colorScheme.onSurface;
    final textColor = Theme.of(context).colorScheme.onSurface;

    // 🔥 Use cardColor for elements that need to stand out slightly from the main background, like search fields and list cards.
    final cardColor = Theme.of(context).cardColor;

    // Stream 1: Fetch the list of IDs the user has dismissed
    final dismissedIdsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser?.uid)
        .collection('dismissedAnnouncements')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        // Use surface for a distinct AppBar color
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: appBarTextColor),
        centerTitle: true,
        title: Text(
          loc.translate('announcements_title'),
          style: TextStyle(color: appBarTextColor, fontWeight: FontWeight.bold),
        ),
        elevation: 1, // Add a slight shadow to the AppBar
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _updateSearchQuery(),
              decoration: InputDecoration(
                hintText: loc.translate('search_announcements_hint'),
                prefixIcon:
                    Icon(Icons.search, color: textColor.withOpacity(0.7)),
                hintStyle: TextStyle(color: textColor.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15), // More rounded corners
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                filled: true,
                // 🔥 Use cardColor (which works well in both modes) for the fill color
                fillColor: cardColor,
              ),
              style: TextStyle(color: textColor),
            ),
          ),

          // Stream 2: Main Announcements List, filtered by dismissed IDs
          Expanded(
            child: StreamBuilder<Set<String>>(
              stream: dismissedIdsStream,
              builder: (context, dismissedSnapshot) {
                // Handle loading or error state for dismissed IDs stream
                if (dismissedSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary));
                }

                if (dismissedSnapshot.hasError || _currentUser == null) {
                  // If there's an error or no user, assume no dismissed IDs
                  debugPrint(
                      "Dismissed Stream Error: ${dismissedSnapshot.error}");
                }

                final Set<String> dismissedIds = dismissedSnapshot.data ?? {};

                // Now, fetch all announcements
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('announcements')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary));
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              loc
                                  .translate(
                                      'error_loading_announcements_template')
                                  .replaceAll('%s', snapshot.error.toString()),
                              style: TextStyle(color: textColor)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          loc.translate('no_announcements_yet'),
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }

                    final allAnnouncements = snapshot.data!.docs;

                    // Filter 1: Exclude dismissed announcements
                    final activeAnnouncements = allAnnouncements.where((doc) {
                      return !dismissedIds.contains(doc.id);
                    }).toList();

                    // Filter 2: Apply search query to active announcements
                    final filteredAnnouncements =
                        activeAnnouncements.where((doc) {
                      final data = doc.data() as Map<String, dynamic>?;
                      if (data == null) return false;

                      final title =
                          (data['title'] as String?)?.toLowerCase() ?? '';
                      final message =
                          (data['message'] as String?)?.toLowerCase() ?? '';

                      return title.contains(_searchQuery) ||
                          message.contains(_searchQuery);
                    }).toList();

                    if (filteredAnnouncements.isEmpty) {
                      return Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? loc.translate('no_new_announcements')
                              : loc
                                  .translate('no_search_results_template')
                                  .replaceAll('%s', _searchQuery),
                          style: TextStyle(color: textColor),
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListView.builder(
                        itemCount: filteredAnnouncements.length,
                        itemBuilder: (context, index) {
                          final doc = filteredAnnouncements[index];
                          // 🔥 Pass only the document, as color selection is now handled inside _buildAnnouncementItem
                          return _buildAnnouncementItem(context, doc);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
