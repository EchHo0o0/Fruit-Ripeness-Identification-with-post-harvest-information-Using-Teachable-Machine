import 'package:flutter/material.dart';
import 'package:harvi/authentication/auth_services.dart';
import 'package:provider/provider.dart';
// 🛠️ NEW IMPORT: Import the helper function from the settings file
import 'package:harvi/home/setting.dart'; // Assuming you put performAppLogout there
// 🌟 NEW IMPORTS for Localization
import 'package:harvi/home/language_provider.dart';
import '../home/app_localizations.dart';

class AdminsScreen extends StatefulWidget {
  const AdminsScreen({super.key});

  @override
  _AdminsScreenState createState() => _AdminsScreenState();
}

class _AdminsScreenState extends State<AdminsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController verificationPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String globalErrorMessage = '';
  bool isProcessing = false;

  // 🎯 REGEX for alphabetical validation: allows letters, spaces, hyphen, apostrophe
  final RegExp _nameRegex = RegExp(r"^[a-zA-Z\s'-]+$");

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    verificationPasswordController.dispose();
    super.dispose();
  }

  bool isValidPassword(String password) {
    // Password must be at least 8 chars, contain uppercase, lowercase, number, special char
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');
    return regex.hasMatch(password);
  }

  // 🛠️ FIX APPLIED HERE: Success dialog with forced 'Logout'
  void _showSuccessAndLogoutDialog(
      String newAdminEmail, AppLocalizations localizations) {
    // Get localized strings for the dialog
    final String title =
        localizations.translate('admin_creation_success_title');
    final String messageTemplate =
        localizations.translate('admin_creation_success_message');
    final String message = messageTemplate.replaceAll('%s', newAdminEmail);
    final String buttonLabel = localizations.translate('button_log_out_now');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              // The requested LOGOUT button
              ElevatedButton.icon(
                onPressed: () async {
                  if (mounted) {
                    await performAppLogout(context);
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(buttonLabel,
                    style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // STEP 1: Show dialog to verify the current admin's password
  void _showPasswordVerificationDialog(AppLocalizations localizations) {
    String verificationError = '';
    verificationPasswordController.clear();

    // Get localized strings for the dialog
    final String title = localizations.translate('verify_identity_title');
    final String passwordLabel =
        localizations.translate('verify_password_field');
    final String buttonCancel = localizations.translate('button_cancel');
    final String buttonVerify = localizations.translate('button_verify');
    final String errorRequired =
        localizations.translate('error_enter_password');
    final String errorFailed =
        localizations.translate('error_verification_failed');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isVerificationPasswordVisible = false;

        return StatefulBuilder(
          builder: (context, setStateInternal) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: verificationPasswordController,
                    obscureText: !isVerificationPasswordVisible,
                    decoration: InputDecoration(
                      labelText: passwordLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(isVerificationPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setStateInternal(() {
                            isVerificationPasswordVisible =
                                !isVerificationPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  if (verificationError.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        verificationError,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(buttonCancel),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String enteredPassword =
                        verificationPasswordController.text.trim();

                    if (enteredPassword.isEmpty) {
                      setStateInternal(() => verificationError = errorRequired);
                      return;
                    }

                    // Perform the actual password verification against Firebase
                    bool isVerified = await context
                        .read<AuthService>()
                        .verifyCurrentAdminPassword(enteredPassword);

                    if (isVerified) {
                      if (!mounted) return;
                      Navigator.of(context).pop(); // Close verification dialog
                      // ➡️ PROCEED TO FINAL ACTION (Sign Up)
                      handleSignUp(localizations);
                    } else {
                      setStateInternal(() {
                        verificationError = errorFailed;
                      });
                    }
                  },
                  child: Text(buttonVerify),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // FINAL ACTION: Create new user
  void handleSignUp(AppLocalizations localizations) async {
    final String firstName = firstNameController.text.trim();
    final String middleName = middleNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    setState(() {
      isProcessing = true;
      globalErrorMessage = '';
    });

    try {
      final String newAdminEmail = emailController.text.trim();

      // 1. Create the new admin account
      String result = await context.read<AuthService>().signUp(
            firstName,
            middleName,
            lastName,
            email,
            password,
            "admin", // Assign the "admin" role
          );

      if (!mounted) return;

      // Use the localized success string
      if (result == localizations.translate('status_signed_up')) {
        // 2. Clear fields
        firstNameController.clear();
        middleNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        // 3. Show the new success/logout dialog
        _showSuccessAndLogoutDialog(newAdminEmail, localizations);

        return;
      } else {
        setState(() => globalErrorMessage = result);
      }
    } catch (error) {
      setState(() => globalErrorMessage = error.toString());
    } finally {
      if (!mounted) return;
      if (isProcessing && globalErrorMessage.isNotEmpty) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 1. Get the AppLocalizations instance
    final localeProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations(localeProvider.locale);

    // 🌟 2. Get localized strings for fields and validation messages
    final String title = localizations.translate('create_admin_title');
    final String fieldFirstName = localizations.translate('field_first_name');
    final String fieldMiddleName = localizations.translate('field_middle_name');
    final String fieldLastName = localizations.translate('field_last_name');
    final String fieldEmail = localizations.translate('field_email');
    final String fieldPassword = localizations.translate('field_password');
    final String fieldConfirmPassword =
        localizations.translate('field_confirm_password');
    final String errorNameRequired = localizations.translate('name_required');
    final String errorNameInvalid =
        localizations.translate('name_invalid_char');
    final String errorEmailRequired = localizations.translate('email_required');
    final String errorEmailInvalid = localizations.translate('email_invalid');
    final String errorPasswordRequired =
        localizations.translate('password_required');
    final String errorPasswordStrong =
        localizations.translate('password_strong_policy');
    final String errorPasswordsMatch =
        localizations.translate('passwords_must_match');
    final String buttonCreate = localizations.translate('button_create');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title, // Localized title
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                if (globalErrorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    child: Text(globalErrorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                  ),
                // 👇 First Name with Validation
                _inputField(
                    context, fieldFirstName, firstNameController, Icons.person,
                    (value) {
                  if (value == null || value.isEmpty) {
                    return errorNameRequired;
                  }
                  // ✅ Name validation using a specific RegExp
                  if (!_nameRegex.hasMatch(value)) {
                    return errorNameInvalid;
                  }
                  return null;
                }),
                // 👇 Middle Name with Validation
                _inputField(
                    context,
                    fieldMiddleName, // Localized
                    middleNameController,
                    Icons.person_outline, (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !_nameRegex.hasMatch(value)) {
                    return errorNameInvalid;
                  }
                  return null;
                }),
                // 👇 Last Name with Validation
                _inputField(context, fieldLastName, lastNameController,
                    Icons.person, // Localized
                    (value) {
                  if (value == null || value.isEmpty) {
                    return errorNameRequired;
                  }
                  if (!_nameRegex.hasMatch(value)) {
                    return errorNameInvalid;
                  }
                  return null;
                }),
                // 👇 Email Field
                _inputField(context, fieldEmail, emailController,
                    Icons.email, // Localized
                    (value) {
                  if (value == null || value.isEmpty) {
                    return errorEmailRequired;
                  }
                  if (!value.contains('@')) {
                    return errorEmailInvalid;
                  }
                  return null;
                }),
                // 👇 Password Field
                _passwordField(
                    context,
                    fieldPassword,
                    passwordController, // Localized
                    Icons.lock,
                    isPasswordVisible, () {
                  setState(() => isPasswordVisible = !isPasswordVisible);
                }, (value) {
                  if (value == null || value.isEmpty) {
                    return errorPasswordRequired;
                  }
                  // ✅ Strong password policy check
                  if (!isValidPassword(value)) {
                    return errorPasswordStrong;
                  }
                  return null;
                }),
                // 👇 Confirm Password Field
                _passwordField(
                    context,
                    fieldConfirmPassword, // Localized
                    confirmPasswordController,
                    Icons.lock,
                    isConfirmPasswordVisible, () {
                  setState(() =>
                      isConfirmPasswordVisible = !isConfirmPasswordVisible);
                }, (value) {
                  if (value == null || value.isEmpty) {
                    return errorPasswordRequired;
                  }
                  // ✅ Direct comparison to ensure passwords match
                  if (value != passwordController.text) {
                    return errorPasswordsMatch;
                  }
                  return null;
                }),
                const SizedBox(height: 20),
                // Using a ternary to toggle between spinner and button is clear and effective
                if (isProcessing) const CircularProgressIndicator(),
                if (!isProcessing)
                  _signUpButton(buttonCreate,
                      localizations), // Pass localized button text
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Changed name to _inputField to follow Dart private convention for helper methods
  Widget _inputField(
    BuildContext context,
    String hint,
    TextEditingController controller,
    IconData icon,
    String? Function(String?) validator,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          hintStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
          errorMaxLines: 2,
        ),
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }

  // Changed name to _passwordField to follow Dart private convention for helper methods
  Widget _passwordField(
    BuildContext context,
    String hint,
    TextEditingController controller,
    IconData icon,
    bool isVisible,
    VoidCallback toggleVisibility,
    String? Function(String?) validator,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          hintStyle:
              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),
          suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).iconTheme.color),
              onPressed: toggleVisibility),
          errorMaxLines: 2,
        ),
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      ),
    );
  }

  // Changed name to _signUpButton to follow Dart private convention for helper methods
  // 🌟 Added String buttonLabel and AppLocalizations localizations arguments
  Widget _signUpButton(String buttonLabel, AppLocalizations localizations) {
    return ElevatedButton(
      onPressed: () {
        // Start the verification flow only if the form is valid
        if (_formKey.currentState!.validate()) {
          _showPasswordVerificationDialog(localizations);
        }
      },
      child: Text(buttonLabel),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
