// lib/home/profile_detail_screen.dart (Updated to use localization keys)
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
// 👈 IMPORTANT: Add your AppLocalizations import here
import '../home/app_localizations.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isLoading = false;
  File? _profileImage;
  String? _currentImagePath;
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String capitalizeEachWord(String input) {
    return input.split(' ').map((word) => capitalize(word)).join(' ');
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        final data = doc.data();
        if (data != null) {
          final pathFromFirestore = data['avatarPath'] as String?;
          File? imageFile;
          if (pathFromFirestore != null && pathFromFirestore.isNotEmpty) {
            if (!pathFromFirestore.startsWith('assets/')) {
              final file = File(pathFromFirestore);
              if (await file.exists()) {
                imageFile = file;
              }
            }
          }

          setState(() {
            _firstNameController.text = data['firstName'] ?? '';
            _middleNameController.text = data['middleName'] ?? '';
            _lastNameController.text = data['lastName'] ?? '';
            _profileImage = imageFile;
            _currentImagePath = pathFromFirestore;
            _updateFullName();
          });
        }
      } catch (e) {
        print("Error loading user info: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                  .translate('error_load_profile'))), // Localized
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _updateFullName() {
    setState(() {
      final first = capitalizeEachWord(_firstNameController.text.trim());
      final middle = capitalizeEachWord(_middleNameController.text.trim());
      final last = capitalizeEachWord(_lastNameController.text.trim());
      _fullName = [first, middle, last].where((s) => s.isNotEmpty).join(' ');
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final imageDirectory = Directory('${appDir.path}/profile_images');
      if (!await imageDirectory.exists()) {
        await imageDirectory.create(recursive: true);
      }
      final savedImage =
          await File(pickedFile.path).copy('${imageDirectory.path}/$fileName');

      setState(() {
        _profileImage = savedImage;
        _currentImagePath = savedImage.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    final localizations = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'firstName': capitalizeEachWord(_firstNameController.text.trim()),
          'middleName': capitalizeEachWord(_middleNameController.text.trim()),
          'lastName': capitalizeEachWord(_lastNameController.text.trim()),
          'avatarPath': _currentImagePath ?? 'assets/profile.png',
        });

        final prefs = await SharedPreferences.getInstance();
        final fullName = _fullName;
        await prefs.setString('fullName', fullName);
        await prefs.setString(
            'profileImagePath', _currentImagePath ?? 'assets/profile.png');

        _updateFullName();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(localizations
                  .translate('profile_update_success'))), // Localized
        );
      } catch (e) {
        print("Error saving changes: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(localizations
                  .translate('error_saving_profile'))), // Localized
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _showSaveConfirmationDialog() async {
    final localizations = AppLocalizations.of(context);
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              localizations.translate('save_confirmation_title')), // Localized
          content: Text(localizations
              .translate('save_confirmation_content')), // Localized
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  Text(localizations.translate('button_cancel')), // Localized
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localizations.translate('button_save'),
                  style: const TextStyle(color: Colors.green)), // Localized
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _saveChanges();
    }
  }

  Widget _buildProfileImage() {
    if (_profileImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_profileImage!),
      );
    } else {
      if (_currentImagePath != null && _currentImagePath == 'assets/logo.png') {
        return const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/logo.png'),
        );
      }
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/profile.png'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 👈 Get the localizations instance
    final localizations = AppLocalizations.of(context);

    final textColor = Theme.of(context).colorScheme.onSurface;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final buttonTextColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.lightGreen
        : primaryColor;

    return Scaffold(
      appBar: AppBar(
          title: Text(localizations.translate('edit_profile'))), // Localized
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildProfileImage(),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.camera_alt, color: buttonTextColor),
                      label: Text(
                        localizations
                            .translate('change_profile_picture'), // Localized
                        style: TextStyle(color: buttonTextColor),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _fullName.isNotEmpty
                          ? '${localizations.translate('welcome_message')}$_fullName!' // Localized prefix
                          : localizations.translate(
                              'welcome_default'), // Localized default
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText:
                            localizations.translate('first_name'), // Localized
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? localizations
                                  .translate('first_name_required') // Localized
                              : null,
                      onChanged: (_) => _updateFullName(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _middleNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText:
                            localizations.translate('middle_name'), // Localized
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) => _updateFullName(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText:
                            localizations.translate('last_name'), // Localized
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? localizations
                                  .translate('last_name_required') // Localized
                              : null,
                      onChanged: (_) => _updateFullName(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : _showSaveConfirmationDialog,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              localizations
                                  .translate('save_changes'), // Localized
                              style: const TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
