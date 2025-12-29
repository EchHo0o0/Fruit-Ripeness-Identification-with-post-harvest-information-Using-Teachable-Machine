// lib/authentication/sign.dart

import 'package:flutter/material.dart';

import 'package:harvi/home/home.dart';

import 'package:harvi/admin/adminscreen.dart';

import 'package:harvi/authentication/mainscreen.dart';

import 'package:provider/provider.dart';

import 'package:harvi/authentication/auth_services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';



// ⬇️ NEW IMPORTS FOR LOCALIZATION

import 'package:harvi/home/app_localizations.dart';

import 'package:harvi/home/language_provider.dart';



class SigninScreen extends StatefulWidget {

  const SigninScreen({super.key});



  @override

  _SigninScreenState createState() => _SigninScreenState();

}



class _SigninScreenState extends State<SigninScreen> {

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  String errorMessage = '';

  bool _obscurePassword = true;

  bool _isLoading = false;



  // ⬇️ NEW: Instance variable for translations

  late AppLocalizations localizations;



  @override

  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }



  // ⬇️ MODIFIED: Helper function to show a translated Snackbar for authentication errors

  void _showAuthError(String message) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(

        content: Row(

          children: [

            const Icon(Icons.error_outline, color: Colors.white),

            const SizedBox(width: 8),

            Expanded(

              child: Text(

                message,

                style: const TextStyle(color: Colors.white),

              ),

            ),

          ],

        ),

        backgroundColor: Colors.red,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        margin: const EdgeInsets.all(10),

      ),

    );

  }



  // ⬇️ MODIFIED: Optimized for overflow and adjusted font sizes for "Welcome, Grower!"

  Widget _buildAestheticGreeting(BuildContext context) {

    localizations =

        AppLocalizations.of(context); // Ensure localization is set here too

    final accentColor = Theme.of(context).primaryColor;

    final hintColor = Theme.of(context).hintColor;



    // Use a smaller base font size to accommodate longer Tagalog translations

    const double baseFontSize = 26;



    return Column(

      children: [

        Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(Icons.spa_outlined, color: accentColor, size: 36),

            const SizedBox(width: 12),

            Flexible(

              // Wrap RichText in Flexible to prevent overflow

              child: RichText(

                text: TextSpan(

                  style: TextStyle(

                    fontSize: baseFontSize, // Use smaller base size

                    fontWeight: FontWeight.w900,

                    color: accentColor,

                    fontFamily: DefaultTextStyle.of(context).style.fontFamily,

                  ),

                  children: <TextSpan>[

                    TextSpan(

                      text: localizations.translate('welcome'),

                      style: TextStyle(

                        fontSize: baseFontSize *

                            0.9, // Make "Welcome" slightly smaller

                      ),

                    ),

                    TextSpan(

                      text: " " +

                          localizations.translate(

                              'grower'), // Add a space and the second word

                      style: const TextStyle(

                        fontStyle: FontStyle.normal,

                      ),

                    ),

                  ],

                ),

              ),

            ),

          ],

        ),

        const SizedBox(height: 10),

        Text(

          localizations.translate('signin_motto'),

          textAlign: TextAlign.center,

          style: TextStyle(

            color: hintColor,

            fontSize: 16,

          ),

        ),

        const SizedBox(height: 20),

      ],

    );

  }



  // ⬇️ MODIFIED: All strings are translated

  void _showForgotPasswordDialog(BuildContext context) {

    final TextEditingController resetEmailController = TextEditingController();

    String dialogMessage = '';

    bool isSent = false;



    showDialog(

      context: context,

      barrierDismissible: true,

      builder: (context) {

        return StatefulBuilder(

          builder: (BuildContext context, StateSetter setState) {

            return Center(

              child: AnimatedScale(

                scale: 1,

                duration: const Duration(milliseconds: 300),

                child: AlertDialog(

                  backgroundColor: Theme.of(context).cardColor,

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(15),

                  ),

                  title: Row(

                    children: [

                      Icon(Icons.lock_reset,

                          color: Theme.of(context).primaryColor),

                      const SizedBox(width: 8),

                      Text(

                        localizations.translate('reset_password'),

                        style: TextStyle(color: Theme.of(context).hintColor),

                      ),

                    ],

                  ),

                  content: Column(

                    mainAxisSize: MainAxisSize.min,

                    children: [

                      TextField(

                        controller: resetEmailController,

                        decoration: InputDecoration(

                          hintText: localizations.translate('enter_your_email'),

                          hintStyle: TextStyle(

                              color: Theme.of(context)

                                  .textTheme

                                  .bodyMedium

                                  ?.color),

                          prefixIcon: Icon(Icons.email,

                              color: Theme.of(context)

                                  .textTheme

                                  .bodyMedium

                                  ?.color),

                          filled: true,

                          fillColor:

                              Theme.of(context).inputDecorationTheme.fillColor,

                          border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide(

                                color: Theme.of(context).dividerColor),

                          ),

                          enabledBorder: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide(

                                color: Theme.of(context).dividerColor),

                          ),

                          focusedBorder: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(10),

                            borderSide: BorderSide(

                                color: Theme.of(context).primaryColor,

                                width: 2),

                          ),

                        ),

                        style: TextStyle(

                            color:

                                Theme.of(context).textTheme.bodyLarge?.color),

                      ),

                      const SizedBox(height: 10),

                      if (dialogMessage.isNotEmpty)

                        Row(

                          children: [

                            Icon(isSent ? Icons.check_circle : Icons.error,

                                color: isSent ? Colors.green : Colors.red,

                                size: 18),

                            const SizedBox(width: 6),

                            Expanded(

                              child: Text(

                                dialogMessage,

                                style: TextStyle(

                                    color: isSent ? Colors.green : Colors.red,

                                    fontSize: 14),

                              ),

                            ),

                          ],

                        ),

                    ],

                  ),

                  actions: [

                    TextButton(

                      onPressed: () => Navigator.of(context).pop(),

                      child: Text(localizations.translate('cancel'),

                          style: const TextStyle(color: Colors.redAccent)),

                    ),

                    ElevatedButton.icon(

                      icon: const Icon(Icons.send, size: 18),

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Theme.of(context).primaryColor,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(

                            borderRadius: BorderRadius.circular(8)),

                      ),

                      onPressed: () async {

                        final email = resetEmailController.text.trim();

                        if (email.isEmpty) {

                          setState(() {

                            dialogMessage = localizations

                                .translate('please_enter_your_email');

                            isSent = false;

                          });

                          return;

                        }

                        try {

                          await FirebaseAuth.instance

                              .sendPasswordResetEmail(email: email);

                          setState(() {

                            dialogMessage =

                                localizations.translate('password_reset_sent');

                            isSent = true;

                          });

                        } catch (e) {

                          setState(() {

                            dialogMessage = localizations

                                .translate('error_invalid_email_or_account');

                            isSent = false;

                          });

                        }

                      },

                      label: Text(localizations.translate('send_email')),

                    ),

                  ],

                ),

              ),

            );

          },

        );

      },

    );

  }



  // ⬇️ MODIFIED: Changed the icon to Icons.language and added text labels

  Widget _buildLanguageSwitcher(

      BuildContext context, LanguageProvider languageProvider) {

    return PopupMenuButton<Locale>(

      // ⬇️ Changed icon to 'language' for clarity

      icon: const Icon(Icons.language, color: Colors.white),

      tooltip: localizations

          .translate('select_language'), // Added tooltip for user-friendliness

      onSelected: (Locale newLocale) {

        languageProvider.setLocale(newLocale);

      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[

        PopupMenuItem<Locale>(

          value: const Locale('en'),

          child: Text(localizations.translate('english')),

        ),

        PopupMenuItem<Locale>(

          value: const Locale('tl'),

          child: Text(localizations.translate('tagalog')),

        ),

      ],

    );

  }



  @override

  Widget build(BuildContext context) {

    // ⬇️ NEW: Get localization and provider instances

    localizations = AppLocalizations.of(context);

    final languageProvider = Provider.of<LanguageProvider>(context);



    // ⬇️ NEW: Get screen size for responsiveness

    final screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(

      backgroundColor: Theme.of(context).colorScheme.background,

      // ⬇️ MODIFIED: Added proper AppBar with Language Switcher

      appBar: AppBar(

        backgroundColor: Theme.of(context).primaryColor,

        elevation: 0,

        title: Text(localizations.translate('sign_in'),

            style: const TextStyle(

                color: Colors.white, fontWeight: FontWeight.bold)),

        centerTitle: true,

        actions: [

          _buildLanguageSwitcher(context, languageProvider),

        ],

      ),

      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 30.0),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Container(

                margin: const EdgeInsets.only(bottom: 30),

                child: Image.asset(

                  'assets/logo.png',

                  // ⬇️ MODIFIED: Responsive height (20% of screen height)

                  height: screenHeight * 0.2,

                ),

              ),

              _buildAestheticGreeting(context),

              _buildTextField(

                context: context,

                controller: emailController,

                // ⬇️ TRANSLATED

                hintText: localizations.translate('email_address'),

                icon: Icons.email,

              ),

              const SizedBox(height: 20),

              _buildTextField(

                context: context,

                controller: passwordController,

                // ⬇️ TRANSLATED

                hintText: localizations.translate('password'),

                icon: Icons.lock,

                obscureText: _obscurePassword,

                suffixIcon: IconButton(

                  icon: Icon(

                    _obscurePassword ? Icons.visibility_off : Icons.visibility,

                    color: Theme.of(context).textTheme.bodyMedium?.color,

                  ),

                  onPressed: () {

                    setState(() {

                      _obscurePassword = !_obscurePassword;

                    });

                  },

                ),

              ),

              const SizedBox(height: 20),

              Align(

                alignment: Alignment.centerRight,

                child: TextButton(

                  onPressed: () => _showForgotPasswordDialog(context),

                  child: Text(

                    // ⬇️ TRANSLATED

                    localizations.translate('forgot_password'),

                    style: TextStyle(

                      color: Theme.of(context).primaryColor,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Theme.of(context).primaryColor,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(12)),

                    elevation: 5,

                  ),

                  onPressed: _isLoading

                      ? null

                      : () async {

                          setState(() {

                            _isLoading = true;

                            errorMessage = '';

                          });



                          final String email = emailController.text.trim();

                          final String password =

                              passwordController.text.trim();



                          if (email.isEmpty || password.isEmpty) {

                            setState(() {

                              _isLoading = false;

                            });

                            // ⬇️ TRANSLATED

                            _showAuthError(

                                localizations.translate('fill_in_all_fields'));

                            return;

                          }



                          try {

                            await FirebaseAuth.instance.signOut();



                            String result = await context

                                .read<AuthService>()

                                .login(email, password);



                            if (!mounted) return;



                            if (result == "Logged In") {

                              User? user = FirebaseAuth.instance.currentUser;



                              if (user != null) {

                                final String userId = user.uid;

                                final snap = await FirebaseFirestore.instance

                                    .collection('users')

                                    .doc(user.uid)

                                    .get();



                                if (snap.exists) {

                                  final userData = snap.data()!;

                                  String role =

                                      userData['role'] as String? ?? 'user';

                                  final prefs =

                                      await SharedPreferences.getInstance();



                                  String firstName =

                                      userData['firstName'] as String? ?? '';

                                  String middleName =

                                      userData['middleName'] as String? ?? '';

                                  String lastName =

                                      userData['lastName'] as String? ?? '';

                                  String fullName =

                                      "$firstName $middleName $lastName".trim();



                                  await prefs.setString('fullName', fullName);

                                  await prefs.setString('email',

                                      userData['email'] as String? ?? '');

                                  await prefs.setString('address',

                                      userData['address'] as String? ?? '');

                                  await prefs.setString('role', role);



                                  String ageString =

                                      (userData['age']?.toString()) ?? '';

                                  await prefs.setString('age', ageString);



                                  setState(() {

                                    _isLoading = false;

                                  });



                                  if (role == 'admin') {

                                    Navigator.pushReplacement(

                                        context,

                                        MaterialPageRoute(

                                            builder: (_) => AdminScreen()));

                                  } else {

                                    Navigator.pushReplacement(

                                        context,

                                        MaterialPageRoute(

                                            builder: (_) =>

                                                HomeScreen(userId: userId)));

                                  }

                                } else {

                                  setState(() {

                                    _isLoading = false;

                                  });

                                  // ⬇️ TRANSLATED

                                  _showAuthError(localizations

                                      .translate('user_data_not_found'));

                                }

                              }

                            } else {

                              setState(() {

                                _isLoading = false;

                              });

                              _showAuthError(result);

                            }

                          } catch (error) {

                            if (!mounted) return;



                            setState(() {

                              _isLoading = false;

                            });

                            // ⬇️ TRANSLATED

                            _showAuthError(localizations

                                .translate('login_failed_check_credentials'));

                          }

                        },

                  child: _isLoading

                      ? const SizedBox(

                          height: 24,

                          width: 24,

                          child: CircularProgressIndicator(

                            color: Colors.white,

                            strokeWidth: 3,

                          ),

                        )

                      : Text(

                          // ⬇️ TRANSLATED

                          localizations.translate('sign_in').toUpperCase(),

                          style: const TextStyle(

                              fontSize: 18, fontWeight: FontWeight.bold),

                        ),

                ),

              ),

              const SizedBox(height: 30),

              GestureDetector(

                onTap: () {

                  Navigator.push(

                      context,

                      MaterialPageRoute(

                          builder: (context) => const MainScreen()));

                },

                child: RichText(

                  text: TextSpan(

                    // ⬇️ TRANSLATED

                    text: localizations.translate('no_account_question'),

                    style: TextStyle(

                        color: Theme.of(context).hintColor, fontSize: 15),

                    children: [

                      TextSpan(

                        // ⬇️ TRANSLATED

                        text: localizations.translate('sign_up_here'),

                        style: TextStyle(

                            color: Theme.of(context).primaryColor,

                            fontWeight: FontWeight.bold),

                      ),

                    ],

                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }



  // ... (keep _buildTextField exactly as it is)

  Widget _buildTextField({

    required BuildContext context,

    required TextEditingController controller,

    required String hintText,

    required IconData icon,

    bool obscureText = false,

    Widget? suffixIcon,

  }) {

    return Container(

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(12),

        boxShadow: [

          BoxShadow(

            color: Theme.of(context).brightness == Brightness.light

                ? const Color.fromARGB(255, 25, 133, 9).withOpacity(0.9)

                : Colors.black.withOpacity(0.5),

            spreadRadius: 1,

            blurRadius: 3,

            offset: const Offset(0, 2),

          ),

        ],

      ),

      child: TextFormField(

        controller: controller,

        obscureText: obscureText,

        decoration: InputDecoration(

          hintText: hintText,

          hintStyle:

              TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),

          prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color),

          suffixIcon: suffixIcon,

          border: InputBorder.none,

          contentPadding:

              const EdgeInsets.symmetric(vertical: 18, horizontal: 15),

        ),

        style: TextStyle(

            fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),

      ),

    );

  }

}