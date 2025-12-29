import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:harvi/authentication/sign.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  final String? harvestingExperience;

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
    String firstName = data['firstName'] ?? '';
    String middleName = data['middleName'] ?? '';
    String lastName = data['lastName'] ?? '';
    String fullName =
        "$firstName ${middleName.isNotEmpty ? middleName + ' ' : ''}$lastName"
            .trim();
    return UserModel(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      fullName: fullName,
      role: data['role'] ?? 'user',
      uid: doc.id,
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      age: (data['age'] is int)
          ? data['age']
          : int.tryParse(data['age']?.toString() ?? '0') ?? 0,
      mobile: data['mobile'] ?? '',
      sex: data['sex'] ?? '',
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

  Future<List<UserModel>> fetchAllUsers() async {
    final firestore = FirebaseFirestore.instance;
    List<UserModel> allUsers = [];
    QuerySnapshot<Map<String, dynamic>>? snapshot;
    DocumentSnapshot<Map<String, dynamic>>? lastDoc;
    try {
      do {
        Query<Map<String, dynamic>> query =
            firestore.collection('users').orderBy('firstName').limit(500);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
        snapshot = await query.get();
        if (snapshot.docs.isEmpty) break;
        for (var doc in snapshot.docs) {
          try {
            allUsers.add(UserModel.fromFirestore(doc));
          } catch (e) {
            debugPrint("Error parsing user ${doc.id}: $e");
          }
        }
        lastDoc = snapshot.docs.last;
      } while (snapshot.docs.isNotEmpty);
    } catch (e) {
      debugPrint("🔥 Error fetching users: $e");
    }
    return allUsers;
  }

  Future<void> _generateAllUsersPdf(List<UserModel> users) async {
    if (users.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No users to generate PDF for.')),
      );
      return;
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) => [
          pw.Center(
            child: pw.Text("All Users Information",
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: [
              'Full Name',
              'Age',
              'Sex',
              'Address',
              'Mobile',
              'Role',
              'Harvesting Experience',
              'Email'
            ],
            data: users
                .map((user) => [
                      user.fullName,
                      user.age.toString(),
                      user.sex,
                      user.address,
                      user.mobile,
                      user.role,
                      user.harvestingExperience ?? 'N/A',
                      user.email
                    ])
                .toList(),
            border: pw.TableBorder.all(width: 1, color: PdfColors.grey500),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.green700),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(5),
          ),
        ],
      ),
    );

    try {
      await Printing.sharePdf(
          bytes: await pdf.save(), filename: "AllUsers.pdf");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All users PDF generated and shared!')),
      );
    } catch (e) {
      debugPrint("❌ Error generating or sharing PDF: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: ${e.toString()}')),
      );
    }
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
      );
    } catch (e) {
      debugPrint("Error signing out: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_for_offline_rounded),
            tooltip: 'Download All Users PDF',
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
              try {
                List<UserModel> users = await fetchAllUsers();
                if (!mounted) return;
                Navigator.of(context).pop();
                await _generateAllUsersPdf(users);
              } catch (e) {
                Navigator.of(context).pop();
                debugPrint("❌ Error: $e");
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Text("Your user list UI goes here"),
      ),
    );
  }
}
