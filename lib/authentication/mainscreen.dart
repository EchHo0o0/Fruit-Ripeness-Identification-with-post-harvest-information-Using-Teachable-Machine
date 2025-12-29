// lib/home/main_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎯 REQUIRED: Import your localization file
import 'package:harvi/home/app_localizations.dart';
import 'sign.dart'; // Ensure this file exists for navigation

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedRole;
  String? selectedSex;
  String? selectedAddress;
  String? harvestingExperience;

  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  // 🎯 NEW: Instance variable to hold our translations
  late AppLocalizations localizations;

  final List<String> barangays = [
    "Bagong Karsada",
    "Balsahan",
    "Bancaan",
    "Bucana Malaki",
    "Bucana Sasahan",
    "Calubcob",
    "Capt. C. Nazareno",
    "Gomez-Zamora",
    "Halang",
    "Humbac",
    "Ibayo Estacion",
    "Ibayo Silangan",
    "Kanluran",
    "Labac",
    "Latoria",
    "Mabolo",
    "Makina",
    "Malainen Bago",
    "Malainen Luma",
    "Molino",
    "Munting Mapino",
    "Muzon",
    "Palangue 1",
    "Palangue 2 & 3",
    "Sabang",
    "SanRoque",
    "Santulan",
    "Sapa",
    "Timalan Balsahan",
    "Timalan Concepcion",
  ];

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  // ⬇️ MODIFIED: Validator now uses the 'localizations' instance
  String? _alphabeticalValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return localizations
          .translate('please_enter_field')
          .replaceAll('{field}', fieldName);
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return localizations
          .translate('alphabetical_only')
          .replaceAll('{field}', fieldName);
    }
    return null;
  }

  bool isPasswordStrong(String password) {
    final strongPassword = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
    );
    return strongPassword.hasMatch(password);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    return emailRegex.hasMatch(email);
  }

  Future<bool> isEmailAlreadyInUse(String email) async {
    try {
      final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        email,
      );
      return list.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      debugPrint('Error checking email existence: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error checking email existence: $e');
      return false;
    }
  }

  // ⬇️ MODIFIED: All SnackBar messages are translated
  bool _validateFormBeforeSignUp() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (selectedSex == null ||
        selectedAddress == null ||
        selectedRole == null ||
        harvestingExperience == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('please_select_all_options')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('passwords_do_not_match')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (!isPasswordStrong(passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(localizations.translate('password_strength_requirements')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('invalid_email_format')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }

    return true;
  }

  // ⬇️ MODIFIED: Dialog text is translated
  void _showConfirmationDialog() {
    if (!_validateFormBeforeSignUp()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(localizations.translate('confirm_account_creation')),
          content: Text(localizations.translate('confirm_account_message')),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.translate('cancel')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(localizations.translate('create')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                handleSignUp();
              },
            ),
          ],
        );
      },
    );
  }

  // ⬇️ MODIFIED: All SnackBar messages are translated
  void handleSignUp() async {
    if (!_validateFormBeforeSignUp()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final emailInUse = await isEmailAlreadyInUse(emailController.text.trim());
    if (emailInUse) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('email_already_in_use')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Save English keys (Farmer, Male) to Firestore, not the translated Tagalog words
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': firstNameController.text.trim(),
        'middleName': middleNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'age': int.parse(ageController.text),
        'address': selectedAddress,
        'role': selectedRole,
        'sex': selectedSex,
        'mobile': '+63${mobileController.text.trim()}',
        'email': emailController.text.trim(),
        'avatarPath': _avatarImage?.path ?? 'assets/profile.png',
        'harvestingExperience': harvestingExperience,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'fullName',
        '${firstNameController.text.trim()} '
            '${lastNameController.text.trim()}',
      );
      await prefs.setString('email', emailController.text.trim());
      if (_avatarImage != null) {
        await prefs.setString('profileImagePath', _avatarImage!.path);
      } else {
        await prefs.remove('profileImagePath');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(localizations.translate('account_created_successfully')),
          backgroundColor: Colors.green,
        ),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations
              .translate('account_creation_failed')
              .replaceAll('{error}', e.message ?? 'Unknown error')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations
              .translate('unexpected_error')
              .replaceAll('{error}', e.toString())),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 NEW: Initialize localizations on build
    localizations = AppLocalizations.of(context);

    // Determine if dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.green[300] : Colors.green[700];
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.green[50];
    final inputFillColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;

    InputDecoration _inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: textColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.5),
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 20),
                  Text(
                    // ⬇️ TRANSLATED
                    localizations.translate('creating_your_account'),
                    style: GoogleFonts.poppins(color: textColor, fontSize: 16),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // --- Step 1: Name and Age ---
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _pickAvatar,
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: primaryColor!.withOpacity(0.2),
                              backgroundImage: _avatarImage != null
                                  ? FileImage(_avatarImage!) as ImageProvider
                                  : null,
                              child: _avatarImage == null
                                  ? Icon(
                                      Icons.person_add,
                                      size: 40,
                                      color: primaryColor,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            // ⬇️ TRANSLATED
                            localizations.translate('tap_to_add_profile'),
                            style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: firstNameController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                localizations.translate('first_name')),
                            validator: (value) => _alphabeticalValidator(
                                value, localizations.translate('first_name')),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: middleNameController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(localizations
                                .translate('middle_name_optional')),
                            validator: (value) {
                              if (value != null &&
                                  value.trim().isNotEmpty &&
                                  !RegExp(r'^[a-zA-Z\s]+$')
                                      .hasMatch(value.trim())) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('alphabetical_only')
                                    .replaceAll('{field}',
                                        localizations.translate('middle_name'));
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: lastNameController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                localizations.translate('last_name')),
                            validator: (value) => _alphabeticalValidator(
                                value, localizations.translate('last_name')),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: ageController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                localizations.translate('age')),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_age');
                              }
                              final age = int.tryParse(value.trim());
                              if (age == null || age < 1 || age > 150) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_valid_age');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              // ⬇️ TRANSLATED
                              localizations.translate('next'),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Step 2: Role, Harvesting Experience, etc. ---
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Role Dropdown
                          _buildDropdown(
                            // ⬇️ TRANSLATED
                            label: localizations.translate('select_role'),
                            // ⬇️ MODIFIED: Map (Key: English, Value: Translated Display)
                            items: {
                              'Farmer': localizations.translate('farmer'),
                              'Vendor': localizations.translate('vendor'),
                              'Consumer': localizations.translate('consumer'),
                            },
                            value: selectedRole,
                            onChanged: (val) =>
                                setState(() => selectedRole = val),
                          ),
                          const SizedBox(height: 16),
                          // Harvesting Experience Dropdown
                          _buildDropdown(
                            // ⬇️ TRANSLATED
                            label: localizations
                                .translate('harvesting_experience_question'),
                            // ⬇️ MODIFIED: Map (Key: English, Value: Translated Display)
                            items: {
                              'Yes': localizations.translate('yes'),
                              'No': localizations.translate('no'),
                            },
                            value: harvestingExperience,
                            onChanged: (val) =>
                                setState(() => harvestingExperience = val),
                          ),
                          const SizedBox(height: 16),
                          // Sex Dropdown
                          _buildDropdown(
                            // ⬇️ TRANSLATED
                            label: localizations.translate('select_sex'),
                            // ⬇️ MODIFIED: Map (Key: English, Value: Translated Display)
                            items: {
                              'Male': localizations.translate('male'),
                              'Female': localizations.translate('female'),
                              'Non-binary':
                                  localizations.translate('non_binary'),
                            },
                            value: selectedSex,
                            onChanged: (val) =>
                                setState(() => selectedSex = val),
                          ),
                          const SizedBox(height: 16),
                          // Barangay Dropdown
                          _buildDropdown(
                            // ⬇️ TRANSLATED
                            label: localizations.translate('select_barangay'),
                            // Barangays are data, so key and value are the same (English/Filipino place names are often fixed)
                            items: Map.fromIterable(barangays,
                                key: (item) => item, value: (item) => item),
                            value: selectedAddress,
                            onChanged: (val) =>
                                setState(() => selectedAddress = val),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: mobileController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                              localizations.translate('mobile_number_hint'),
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_mobile');
                              }
                              final mobile = value.trim();
                              final mobileRegex = RegExp(r'^9[0-9]{9}$');

                              if (!mobileRegex.hasMatch(mobile)) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('mobile_number_format');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[600],
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    // ⬇️ TRANSLATED
                                    localizations.translate('back'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() &&
                                        selectedRole != null &&
                                        selectedSex != null &&
                                        selectedAddress != null &&
                                        harvestingExperience != null) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    } else if (_formKey.currentState!
                                        .validate()) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(localizations.translate(
                                              'please_select_all_options')),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    // ⬇️ TRANSLATED
                                    localizations.translate('next'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Step 3: Email, Password, Confirm Password ---
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                localizations.translate('email')),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_email');
                              }
                              if (!isValidEmail(value.trim())) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_valid_email');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                    localizations.translate('password'))
                                .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_enter_password');
                              }
                              if (!isPasswordStrong(value)) {
                                // ⬇️ TRANSLATED
                                return localizations.translate(
                                    'password_strength_requirements');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: confirmPasswordController,
                            style: GoogleFonts.poppins(color: textColor),
                            // ⬇️ TRANSLATED
                            decoration: _inputDecoration(
                                    localizations.translate('confirm_password'))
                                .copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_confirmPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('please_confirm_password');
                              }
                              if (value != passwordController.text) {
                                // ⬇️ TRANSLATED
                                return localizations
                                    .translate('passwords_do_not_match');
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[600],
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    // ⬇️ TRANSLATED
                                    localizations.translate('back'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _showConfirmationDialog,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    // ⬇️ TRANSLATED
                                    localizations.translate('sign_up'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text(
                // ⬇️ TRANSLATED
                localizations.translate('create_account'),
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
    );
  }

  // ⬇️ --- REFACTORED WIDGET --- ⬇️
  // 1. Changed items type to Map<String, String> (Key = data to save, Value = display text).
  // 2. Uses labelText in InputDecoration to keep the label/question visible after selection (UX fix).
  Widget _buildDropdown({
    required String label,
    required Map<String, String> items, // <-- Map for Key/Value
    String? value,
    required void Function(String?) onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputFillColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final primaryColor = isDarkMode ? Colors.green[300] : Colors.green[700];

    return DropdownButtonFormField<String>(
      // We check the value against the *key* (e.g., 'Farmer')
      value: value,

      // 🎯 FIX: Use decoration with labelText to keep the question visible
      decoration: InputDecoration(
        labelText: label, // <-- THIS KEEPS THE QUESTION VISIBLE
        labelStyle: TextStyle(
          color: textColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor!, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
      // Build items from the Map's entries
      items: items.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key, // Save the English key (e.g., 'Farmer')
          child: Text(
              entry.value, // Display the translated value (e.g., 'Magsasaka')
              style: GoogleFonts.poppins(color: textColor)),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) {
        if (val == null || val.isEmpty) {
          // ⬇️ TRANSLATED
          return localizations.translate('please_select_option');
        }
        return null;
      },
      dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: textColor),
    );
  }
}

extension on FirebaseAuth {
  Future fetchSignInMethodsForEmail(String email) async {}
}
