// lib/main.dart (Updated with Localization Properties)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:harvi/home/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:harvi/home/home.dart';
import 'package:harvi/authentication/auth_services.dart';
import 'package:harvi/authentication/sign.dart';
import 'package:harvi/theme_provider.dart';

// 🎯 REQUIRED: Import your localization file
import 'package:harvi/home/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // You can remove this line after testing is complete
  await FirebaseAuth.instance.signOut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        // 🎯 NEW: Add the LanguageProvider
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: const ThemedApp(),
    );
  }
}

// lib/main.dart

// ... (all other imports are correct)

class ThemedApp extends StatelessWidget {
  const ThemedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch both ThemeProvider and LanguageProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider =
        Provider.of<LanguageProvider>(context); // <<< NEW WATCH

    return MaterialApp(
      title: "APP",

      // 🎯 NEW: Use the locale from the LanguageProvider
      locale: languageProvider.locale,

      // 🚨 REMOVE THESE TWO LINES - They are causing the error
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // 🚨 END OF FIX

      theme: ThemeProvider.lightTheme,
      darkTheme: ThemeProvider.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // The starting point is now the AuthWrapper
      home: const AuthWrapper(),
    );
  }
}

// ... (rest of main.dart is correct)

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    // The following code checks if the user is logged in
    return user != null
        ? HomeScreen(
            userId: user.uid,
          )
        : SigninScreen(); // Added const for consistency
  }
}
