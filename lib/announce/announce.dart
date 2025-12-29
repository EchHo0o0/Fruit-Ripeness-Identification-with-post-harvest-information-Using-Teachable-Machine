import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 🌟 NEW IMPORTS for Localization
import 'package:provider/provider.dart';
import 'package:harvi/home/language_provider.dart'; // Assuming this holds your LanguageProvider
import '../home/app_localizations.dart'; // Assuming this holds your AppLocalizations

class AdminAnnouncementScreen extends StatefulWidget {
  const AdminAnnouncementScreen({super.key}); // Added const constructor

  @override
  _AdminAnnouncementScreenState createState() =>
      _AdminAnnouncementScreenState();
}

class _AdminAnnouncementScreenState extends State<AdminAnnouncementScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Dialog for posting confirmation
  Future<void> _showPostConfirmationDialog(
      AppLocalizations localizations) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Localized Title
          title: Text(localizations.translate("post_confirm_title")),
          // Localized Content
          content: Text(localizations.translate("post_confirm_content")),
          actions: [
            TextButton(
              // Localized Cancel Button
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localizations.translate("button_cancel")),
            ),
            TextButton(
              // Localized Post Button
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.translate("button_post")),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _postAnnouncement(localizations);
    }
  }

  Future<void> _postAnnouncement(AppLocalizations localizations) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final userData = userDoc.data();

    // Safety check: only admins should post
    if (userData?['role'] != 'admin') return;

    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      // Combining the message for storage
      final combinedMessage =
          'Title: ${_titleController.text}\nDescription: ${_descriptionController.text}';

      await FirebaseFirestore.instance.collection('announcements').add({
        'message': combinedMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descriptionController.clear();
      if (!mounted) return;
      // Localized SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(localizations.translate("status_announcement_posted"))));
    }
  }

  // Dialog for editing confirmation
  Future<void> _editAnnouncement(String docId, String currentMessage,
      AppLocalizations localizations) async {
    final messageController = TextEditingController(text: currentMessage);

    // Localized Strings for Dialogs
    final String editTitle = localizations.translate("edit_dialog_title");
    final String editLabel = localizations.translate("edit_field_label");
    final String confirmTitle = localizations.translate("save_changes_title");
    final String confirmContent =
        localizations.translate("save_changes_content");
    final String buttonCancel = localizations.translate("button_cancel");
    final String buttonSave = localizations.translate("button_save");
    final String statusSaved =
        localizations.translate("status_announcement_saved");

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Localized Title
        title: Text(editTitle),
        content: TextField(
          controller: messageController,
          maxLines: 4,
          // Localized Label
          decoration: InputDecoration(labelText: editLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonCancel),
          ),
          TextButton(
            onPressed: () async {
              bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // Localized Title
                    title: Text(confirmTitle),
                    // Localized Content
                    content: Text(confirmContent),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(buttonCancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(buttonSave),
                      ),
                    ],
                  );
                },
              );

              if (confirmed == true) {
                await FirebaseFirestore.instance
                    .collection('announcements')
                    .doc(docId)
                    .update({'message': messageController.text});
                if (!mounted) return;
                Navigator.pop(context); // Close the edit dialog
                // Localized SnackBar
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(statusSaved)));
              }
            },
            child: Text(buttonSave),
          ),
        ],
      ),
    );
  }

  // Dialog for delete confirmation
  Future<void> _showDeleteConfirmationDialog(
      String docId, AppLocalizations localizations) async {
    // Localized Strings for Dialogs
    final String confirmTitle = localizations.translate("delete_confirm_title");
    final String confirmContent =
        localizations.translate("delete_confirm_content");
    final String buttonCancel = localizations.translate("button_cancel");
    final String buttonDelete = localizations.translate("button_delete");

    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Localized Title
          title: Text(confirmTitle),
          // Localized Content
          content: Text(confirmContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(buttonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              // Localized Delete Button
              child:
                  Text(buttonDelete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deleteAnnouncement(docId, localizations);
    }
  }

  Future<void> _deleteAnnouncement(
      String docId, AppLocalizations localizations) async {
    await FirebaseFirestore.instance
        .collection('announcements')
        .doc(docId)
        .delete();
    if (!mounted) return;
    // Localized SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(localizations.translate("status_announcement_deleted"))));
  }

  void _showViewDialog(String message, AppLocalizations localizations) {
    // Localized Strings for Dialogs
    final String dialogTitle = localizations.translate("view_dialog_title");
    final String buttonClose = localizations.translate("button_close");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Localized Title
        title: Text(dialogTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(buttonClose),
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

    // 🌟 2. Get Localized Strings for the main screen
    final String screenTitle =
        localizations.translate("announcement_title_screen");
    final String fieldTitle = localizations.translate("field_title");
    final String fieldDescription =
        localizations.translate("field_description");
    final String buttonPost =
        localizations.translate("button_post_announcement");
    final String noAnnouncements =
        localizations.translate("no_announcements_found");
    final String noTitle = localizations.translate("list_no_title");
    final String noDate = localizations.translate("list_no_date");
    final String noMessage = localizations.translate("list_no_message");

    return Scaffold(
      // Localized AppBar Title
      appBar: AppBar(title: Text(screenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              // Localized Label
              decoration: InputDecoration(labelText: fieldTitle),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              // Localized Label
              decoration: InputDecoration(labelText: fieldDescription),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              // Pass localizations instance to the handler
              onPressed: () => _showPostConfirmationDialog(localizations),
              // Localized Button Text
              child: Text(buttonPost),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // Localized Empty State Message
                    return Center(child: Text(noAnnouncements));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            // Safely extract title/first line, default to localized 'No Title'
                            data['message']?.split('\n')?.first.isNotEmpty ==
                                    true
                                ? data['message']!.split('\n').first
                                : noTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            // Safely format timestamp, default to localized 'No Date'
                            (data['timestamp'] as Timestamp?) != null
                                ? (data['timestamp'] as Timestamp)
                                    .toDate()
                                    .toString()
                                : noDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility,
                                    color: Colors.blue),
                                // Pass localizations instance to the handler
                                onPressed: () => _showViewDialog(
                                    data['message'] ?? noMessage,
                                    localizations),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                                // Pass localizations instance to the handler
                                onPressed: () => _editAnnouncement(
                                    doc.id,
                                    data['message'] ?? noMessage,
                                    localizations),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                // Pass localizations instance to the handler
                                onPressed: () => _showDeleteConfirmationDialog(
                                    doc.id, localizations),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
