import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvi/authentication/sign.dart'; // Assuming this path is correct

import 'package:pdf/pdf.dart'; // For PdfColors
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// 🌟 NEW IMPORTS for Localization
import 'package:provider/provider.dart';
import 'package:harvi/home/language_provider.dart';
import '../home/app_localizations.dart';

// UserModel class
class UserModel {
  final String firstName;
  final String middleName;
  final String lastName;
  final String fullName;
  final String role;
  final String uid;
  final String email;
  final String address;
  final int age;
  final String mobile;
  final String sex;
  final String? harvestingExperience; // Nullable string

  UserModel({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.fullName,
    required this.role,
    required this.uid,
    required this.email,
    required this.address,
    required this.age,
    required this.mobile,
    required this.sex,
    this.harvestingExperience,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Defensive handling for missing fields and type conversions
    String firstName = data['firstName'] ?? '';
    String middleName = data['middleName'] ?? '';
    String lastName = data['lastName'] ?? '';

    // Construct fullName, trim to remove extra spaces if middleName is empty
    String fullName =
        "$firstName ${middleName.isNotEmpty ? middleName + ' ' : ''}$lastName"
            .trim();

    return UserModel(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      fullName: fullName,
      role: data['role'] ?? 'user', // Default role if not found
      uid: doc.id, // Document ID is typically the user UID
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      age: (data['age'] is int)
          ? data['age'] // If already an int, use directly
          : int.tryParse(data['age']?.toString() ?? '0') ??
              0, // Try parsing if not int, default to 0
      mobile: data['mobile'] ?? '',
      sex: data['sex'] ?? '',
      // Directly assign nullable string, 'N/A' for display handled in UI
      harvestingExperience: data['harvestingExperience'],
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Function to generate PDF for a single user
  Future<void> _generatePdf(
      UserModel user, AppLocalizations localizations) async {
    // Get localized labels
    final String pdfTitle = localizations.translate("pdf_user_info_title");
    final String labelFullName = localizations.translate("label_full_name");
    final String labelAge = localizations.translate("label_age");
    final String labelSex = localizations.translate("label_sex");
    final String labelAddress = localizations.translate("label_address");
    final String labelMobile = localizations.translate("label_mobile");
    final String labelRole = localizations.translate("label_role");
    final String labelHarvestExp =
        localizations.translate("label_harvesting_exp");
    final String labelEmail = localizations.translate("label_email");
    final String labelNA = localizations.translate("label_na");

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(pdfTitle, // Localized PDF title
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("$labelFullName: ${user.fullName}"),
            pw.Text("$labelAge: ${user.age}"),
            pw.Text("$labelSex: ${user.sex}"),
            pw.Text("$labelAddress: ${user.address}"),
            pw.Text("$labelMobile: ${user.mobile}"),
            pw.Text("$labelRole: ${user.role}"),
            pw.Text(
                "$labelHarvestExp: ${user.harvestingExperience ?? labelNA}"),
            pw.Text("$labelEmail: ${user.email}"),
          ],
        ),
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${user.fullName}.pdf");
      await file.writeAsBytes(await pdf.save());

      // Share the PDF using the system's share sheet
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: "${user.fullName}.pdf");

      if (!mounted) return;
      // Localized Success SnackBar
      final String statusMessage = localizations
          .translate('pdf_status_generating')
          .replaceAll('%s', user.fullName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(statusMessage)),
      );
    } catch (e) {
      debugPrint("Error generating or sharing PDF: $e");
      if (!mounted) return;
      // Localized Error SnackBar
      final String errorMessage = localizations
          .translate('pdf_status_error')
          .replaceAll('%s', e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  /// Function to show user details in a dialog
  void _showUserDetails(UserModel user, AppLocalizations localizations) {
    // Get localized labels
    final String dialogTitle = localizations.translate("user_details_title");
    final String labelFullName = localizations.translate("label_full_name");
    final String labelAge = localizations.translate("label_age");
    final String labelSex = localizations.translate("label_sex");
    final String labelAddress = localizations.translate("label_address");
    final String labelMobile = localizations.translate("label_mobile");
    final String labelRole = localizations.translate("label_role");
    final String labelHarvestExp =
        localizations.translate("label_harvesting_exp");
    final String labelEmail = localizations.translate("label_email");
    final String labelNA = localizations.translate("label_na");
    final String buttonClose = localizations.translate("button_close");
    final String buttonGeneratePdf =
        localizations.translate("button_generate_pdf");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // Localized Title
        title: Text(dialogTitle),
        content: SingleChildScrollView(
          // Use SingleChildScrollView for long content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$labelFullName: ${user.fullName}"),
              Text("$labelAge: ${user.age}"),
              Text("$labelSex: ${user.sex}"),
              Text("$labelAddress: ${user.address}"),
              Text("$labelMobile: ${user.mobile}"),
              Text("$labelRole: ${user.role}"),
              Text("$labelHarvestExp: ${user.harvestingExperience ?? labelNA}"),
              Text("$labelEmail: ${user.email}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            // Localized Close button
            child: Text(buttonClose),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            // Localized Generate PDF button
            child: Text(buttonGeneratePdf),
            onPressed: () {
              Navigator.pop(context); // Close dialog before generating PDF
              _generatePdf(user, localizations); // Pass localizations
            },
          ),
        ],
      ),
    );
  }

  /// Function to delete a user
  Future<void> _deleteUser(
      String userId, AppLocalizations localizations) async {
    // Get localized strings
    final String confirmTitle =
        localizations.translate("delete_user_confirm_title");
    final String confirmContent =
        localizations.translate("delete_user_confirm_content");
    final String buttonCancel = localizations.translate("button_cancel");
    final String buttonDelete = localizations.translate("button_delete");
    final String statusSuccess = localizations.translate("status_user_deleted");
    final String statusError = localizations
        .translate("pdf_status_error")
        .replaceAll(
            'PDF',
            localizations.translate(
                'label_role')); // Re-use template for user deletion error

    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Localized Title
          title: Text(confirmTitle),
          // Localized Content
          content: Text(confirmContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(buttonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              // Localized Delete button
              child:
                  Text(buttonDelete, style: const TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .delete();
        if (!mounted) return;
        // Localized Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(statusSuccess)),
        );
      } catch (e) {
        debugPrint("Error deleting user: $e");
        if (!mounted) return;
        // Localized Error SnackBar
        final String errorMessage = statusError.replaceAll('%s', e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  /// Fetches all users from Firestore.
  Future<List<UserModel>> fetchAllUsers() async {
    final firestore = FirebaseFirestore.instance;
    List<UserModel> allUsers = [];

    debugPrint("fetchAllUsers: Starting user fetch (simplified query)...");

    try {
      // SIMPLIFIED QUERY: Removed orderBy and pagination for initial test
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .get(); // Direct get, no ordering or pagination

      debugPrint(
          "fetchAllUsers: Query returned ${snapshot.docs.length} documents.");

      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          try {
            allUsers.add(UserModel.fromFirestore(doc));
          } catch (e) {
            debugPrint(
                "fetchAllUsers: ERROR parsing user document ${doc.id}: $e");
          }
        }
      } else {
        debugPrint(
            "fetchAllUsers: No documents found in this simplified query.");
      }
    } catch (e) {
      debugPrint("fetchAllUsers: 🔥 Error during simplified user fetch: $e");
    }

    debugPrint(
        "fetchAllUsers: Finished fetching. Total users found: ${allUsers.length}");
    return allUsers; // Always return a List<UserModel>, even if empty
  }

  /// Function to generate PDF for all users
  Future<void> _generateAllUsersPdf(
      List<UserModel> users, AppLocalizations localizations) async {
    // Get localized strings
    final String noUsersToGenerate =
        localizations.translate('pdf_no_users_to_generate');
    final String pdfTitle = localizations.translate("pdf_all_users_title");
    final String successMessage =
        localizations.translate('pdf_all_status_generating');
    final String errorMessage = localizations.translate('pdf_all_status_error');

    // Get localized table headers
    final List<String> tableHeaders = [
      localizations.translate('label_full_name'),
      localizations.translate('label_age'),
      localizations.translate('label_sex'),
      localizations.translate('label_address'),
      localizations.translate('label_mobile'),
      localizations.translate('label_role'),
      localizations.translate('label_harvesting_exp'),
      localizations.translate('label_email'),
    ];
    final String labelNA = localizations.translate("label_na");

    if (users.isEmpty) {
      if (!mounted) return;
      // Localized SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(noUsersToGenerate)),
      );
      return; // Exit if no users
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        // Use MultiPage for content that spans multiple pages
        pageFormat: PdfPageFormat.a4.landscape, // Use landscape for wider table
        build: (pw.Context context) => [
          pw.Center(
            // Localized PDF Title
            child: pw.Text(pdfTitle,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          // Create a table for better organization of user data
          pw.Table.fromTextArray(
              headers: tableHeaders, // Localized Headers
              data: users
                  .map((user) => [
                        user.fullName,
                        user.age.toString(),
                        user.sex,
                        user.address,
                        user.mobile,
                        user.role,
                        user.harvestingExperience ??
                            labelNA, // Display localized 'N/A' for nulls
                        user.email,
                      ])
                  .toList(),
              border: pw.TableBorder.all(
                  width: 1, color: PdfColors.grey500), // Add border color
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white), // White header text
              headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.green700), // Darker green header
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(5),
              columnWidths: {
                // Adjust column widths for better layout in landscape
                0: const pw.FlexColumnWidth(2), // Full Name
                1: const pw.FlexColumnWidth(0.8), // Age
                2: const pw.FlexColumnWidth(1), // Sex
                3: const pw.FlexColumnWidth(2), // Address
                4: const pw.FlexColumnWidth(1.5), // Mobile
                5: const pw.FlexColumnWidth(1), // Role
                6: const pw.FlexColumnWidth(2), // Harvesting Experience
                7: const pw.FlexColumnWidth(2.5), // Email
              }),
        ],
      ),
    );

    try {
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/AllUsers.pdf");
      await file.writeAsBytes(await pdf.save());

      // Share the PDF using the system's share sheet
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: "AllUsers.pdf");

      if (!mounted) return;
      // Localized Success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } catch (e) {
      debugPrint("Error generating or sharing all users PDF: $e");
      if (!mounted) return;
      // Localized Error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage.replaceAll('%s', e.toString()))),
      );
    }
  }

  // New function to show the download confirmation dialog
  void _showDownloadConfirmationDialog(AppLocalizations localizations) async {
    // Get localized strings
    final String confirmTitle =
        localizations.translate('download_confirm_title');
    final String confirmContent =
        localizations.translate('download_confirm_content');
    final String buttonCancel = localizations.translate('button_cancel');
    final String buttonDownload = localizations.translate('button_download');
    final String loadingMessage = localizations
        .translate('pdf_no_users_found_message'); // Re-using for the error case
    final String failedToFetch =
        localizations.translate('failed_to_fetch_users');

    final bool? confirmDownload = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Localized Title
          title: Text(confirmTitle),
          // Localized Content
          content: Text(confirmContent),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(buttonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              // Localized Download button
              child: Text(buttonDownload,
                  style: const TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmDownload == true) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      );

      try {
        debugPrint("📄 Fetching users for PDF generation...");
        List<UserModel> users = await fetchAllUsers();
        if (!mounted) {
          Navigator.of(context).pop();
          return;
        }
        Navigator.of(context).pop(); // Dismiss loading dialog
        if (users.isNotEmpty) {
          debugPrint("📄 Users fetched: ${users.length}. Generating PDF...");
          await _generateAllUsersPdf(
              users, localizations); // Pass localizations
        } else {
          debugPrint("📄 No users found. Displaying message.");
          // Localized SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loadingMessage)),
          );
        }
      } catch (e) {
        debugPrint("❌ Error fetching users for PDF: $e");
        if (!mounted) return;
        Navigator.of(context).pop(); // Dismiss loading dialog on error
        // Localized SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failedToFetch.replaceAll('%s', e.toString()))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 1. Get the AppLocalizations instance
    final localeProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations(localeProvider.locale);

    // 🌟 2. Get Localized Strings for the main screen
    final String screenTitle = localizations.translate('user_list_title');
    final String searchLabel = localizations.translate('search_label');
    final String tooltipDownload =
        localizations.translate('tooltip_download_all');
    final String noUsersFound = localizations.translate('no_users_found');
    final String noUsersMatched = localizations.translate('no_users_matched');
    final String tooltipViewDetails =
        localizations.translate('tooltip_view_details');
    final String tooltipDeleteUser =
        localizations.translate('tooltip_delete_user');

    // Get list item labels
    final String labelEmail = localizations.translate('label_email');
    final String labelRole = localizations.translate('label_role');
    final String labelAddress = localizations.translate('label_address');
    final String labelAge = localizations.translate('label_age');
    final String labelHarvestExp =
        localizations.translate('label_harvesting_exp');
    final String labelNA = localizations.translate('label_na');

    return Scaffold(
      appBar: AppBar(
        // Localized Title
        title: Text(
          screenTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[700], // Darker green app bar
        foregroundColor: Colors.white, // White text and icons
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            // Localized Tooltip
            tooltip: tooltipDownload,
            // Pass localizations to the confirmation dialog
            onPressed: () => _showDownloadConfirmationDialog(localizations),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                // Localized Search Label
                labelText: searchLabel,
                labelStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(12), // More rounded corners
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: Colors.green.shade700,
                      width: 2), // Highlight on focus
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() => _searchText = value.toLowerCase());
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('StreamBuilder Error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Localized 'No users found'
                  return Center(child: Text(noUsersFound));
                }

                final users = snapshot.data!.docs
                    .map((doc) => UserModel.fromFirestore(doc))
                    .where((user) =>
                        user.fullName.toLowerCase().contains(_searchText))
                    .toList();

                if (users.isEmpty) {
                  // Localized 'No users matched search'
                  return Center(child: Text(noUsersMatched));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      elevation: 3, // Subtle shadow for cards
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded card corners
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        title: Text(
                          user.fullName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '$labelEmail: ${user.email}'), // Localized Label
                            Text('$labelRole: ${user.role}'), // Localized Label
                            Text(
                                '$labelAddress: ${user.address}'), // Localized Label
                            Text('$labelAge: ${user.age}'), // Localized Label
                            Text(
                                '$labelHarvestExp: ${user.harvestingExperience ?? labelNA}'), // Localized Label
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline_rounded,
                                  color: Colors.blue), // Info icon
                              // Pass localizations to the handler
                              onPressed: () =>
                                  _showUserDetails(user, localizations),
                              // Localized Tooltip
                              tooltip: tooltipViewDetails,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever_rounded,
                                  color: Colors.red), // Delete icon
                              // Pass localizations to the handler
                              onPressed: () =>
                                  _deleteUser(user.uid, localizations),
                              // Localized Tooltip
                              tooltip: tooltipDeleteUser,
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
    );
  }
}
