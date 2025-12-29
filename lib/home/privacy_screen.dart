// lib/home/privacy_screen.dart (Updated to use localization keys)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// 👈 IMPORTANT: Add your AppLocalizations import here
import '../home/app_localizations.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool _isLoading = false;

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // NOTE: This RegExp is not used directly, but its components are used in the validator.
  // final RegExp _passwordRegExp =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  String? _validatePassword(String? value) {
    // Get localizations inside the method
    final localizations = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return localizations.translate('password_required');
    }
    if (value.length < 8) {
      return localizations.translate('password_min_length');
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return localizations.translate('password_uppercase');
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return localizations.translate('password_lowercase');
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return localizations.translate('password_digit');
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return localizations.translate('password_special_char');
    }
    return null; // Password is valid
  }

  Future<void> _changePassword() async {
    final localizations = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      final email = user?.email ?? '';

      if (user == null || email.isEmpty) {
        _showSnackBar(localizations.translate('error_user_not_logged_in'));
        return;
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: _currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPasswordController.text);

      _showSnackBar(localizations.translate('password_change_success'));

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _isCurrentPasswordVisible = false;
        _isNewPasswordVisible = false;
        _isConfirmPasswordVisible = false;
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = localizations.translate('error_unknown');
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = localizations.translate('error_reauth_failed');
      } else if (e.code == 'too-many-requests') {
        errorMessage = localizations.translate('error_too_many_requests');
      } else if (e.code == 'requires-recent-login') {
        errorMessage = localizations.translate('error_requires_recent_login');
      } else if (e.code == 'weak-password') {
        errorMessage = localizations.translate('error_weak_password');
      }
      _showSnackBar(
          '${localizations.translate('error_unknown')}: $errorMessage'); // Updated error message format
    } catch (e) {
      _showSnackBar(
          '${localizations.translate('error_unknown')}: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendPasswordResetEmail() async {
    final localizations = AppLocalizations.of(context);
    final user = _auth.currentUser;
    final email = user?.email;

    if (email == null || email.isEmpty) {
      _showSnackBar(localizations.translate('error_email_not_found'));
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translate('error_password_reset_title')),
          content: Text(
              '${localizations.translate('error_password_reset_confirm')}$email?'),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.translate('button_cancel')),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: Text(localizations.translate('button_send_reset_link')),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _showSnackBar(
          '${localizations.translate('error_password_reset_link_sent')}$email${localizations.translate('error_password_reset_check_email')}');
    } on FirebaseAuthException catch (e) {
      String errorMessage = localizations
          .translate('error_sending_reset_email'); // General error message
      if (e.code == 'user-not-found') {
        errorMessage =
            '${localizations.translate('error_user_not_registered')} $email.';
      }
      _showSnackBar(errorMessage);
    } catch (e) {
      _showSnackBar(localizations.translate('error_unknown'));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildVisibilityToggle({
    required bool isVisible,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 👈 Get the localizations instance
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('security')), // Localized
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.translate('change_password_title'), // Localized
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // --- Current Password Field ---
              TextFormField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText:
                      localizations.translate('current_password'), // Localized
                  border: const OutlineInputBorder(),
                  suffixIcon: _buildVisibilityToggle(
                    isVisible: _isCurrentPasswordVisible,
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isCurrentPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations
                        .translate('password_required'); // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // --- New Password Field ---
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText:
                      localizations.translate('new_password'), // Localized
                  hintText:
                      localizations.translate('new_password_hint'), // Localized
                  border: const OutlineInputBorder(),
                  suffixIcon: _buildVisibilityToggle(
                    isVisible: _isNewPasswordVisible,
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isNewPasswordVisible,
                validator: _validatePassword, // Uses the custom validator
              ),
              const SizedBox(height: 10),

              // --- Confirm New Password Field ---
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: localizations
                      .translate('confirm_new_password'), // Localized
                  border: const OutlineInputBorder(),
                  suffixIcon: _buildVisibilityToggle(
                    isVisible: _isConfirmPasswordVisible,
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations
                        .translate('confirm_password_required'); // Localized
                  }
                  if (value != _newPasswordController.text) {
                    return localizations
                        .translate('passwords_do_not_match'); // Localized
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Change Password Button ---
              ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        localizations
                            .translate('change_password_button'), // Localized
                        style: const TextStyle(fontSize: 16),
                      ),
              ),

              const SizedBox(height: 10),

              // --- NEW: Forgot Password Button ---
              TextButton(
                onPressed: _isLoading ? null : _sendPasswordResetEmail,
                child: Text(
                  localizations
                      .translate('forgot_password_button'), // Localized
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
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
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
