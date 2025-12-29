// lib/home/settings_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvi/authentication/sign.dart';
import 'package:harvi/home/app_localizations.dart';
import 'package:harvi/home/language_provider.dart';
import 'package:harvi/home/privacy_screen.dart';
import 'package:provider/provider.dart';
import 'package:harvi/theme_provider.dart';
import 'package:harvi/home/profile_detail_screen.dart';
import 'package:harvi/home/about_us_screen.dart';
import 'package:harvi/home/help_center_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> performAppLogout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('fullName');
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                SigninScreen()), // Added const for consistency
        (Route<dynamic> route) => false,
      );
    }
  } catch (e) {
    // ignore: avoid_print
    print("Error during performAppLogout: $e");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during logout: ${e.toString()}')),
      );
    }
  }
}

// CONVERTED TO STATEFULWIDGET TO MANAGE LOADING STATE
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // STATE VARIABLE TO MANAGE THE LOADING INDICATOR
  bool _isLoading = false;

  void _showLanguageSelectionDialog(
      BuildContext context, AppLocalizations localizations) {
    final langProvider = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(localizations.translate('language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(localizations.translate('english')),
                onTap: () async {
                  // 1. Dismiss the dialog
                  Navigator.of(dialogContext).pop();

                  // 2. Set loading state to show spinner
                  setState(() {
                    _isLoading = true;
                  });

                  // 3. Change locale and wait for change
                  langProvider.setLocale(const Locale('en'));

                  // 4. Wait a brief moment for the app's root to fully rebuild and load resources
                  await Future.delayed(const Duration(milliseconds: 300));

                  // 5. Turn off loading state and rebuild the settings screen with the new locale
                  setState(() {
                    _isLoading = false;
                  });
                },
                trailing: langProvider.locale.languageCode == 'en'
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.secondary)
                    : null,
              ),
              ListTile(
                title: Text(localizations.translate('tagalog')),
                onTap: () async {
                  // 1. Dismiss the dialog
                  Navigator.of(dialogContext).pop();

                  // 2. Set loading state to show spinner
                  setState(() {
                    _isLoading = true;
                  });

                  // 3. Change locale and wait for change
                  langProvider.setLocale(const Locale('tl'));

                  // 4. Wait a brief moment for the app's root to fully rebuild and load resources
                  await Future.delayed(const Duration(milliseconds: 300));

                  // 5. Turn off loading state and rebuild the settings screen with the new locale
                  setState(() {
                    _isLoading = false;
                  });
                },
                trailing: langProvider.locale.languageCode == 'tl'
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.secondary)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(localizations.translate("confirm_logout")),
          content: Text(localizations.translate("confirm_logout_message")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.translate("cancel")),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await performAppLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(localizations.translate("yes_logout")),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingRow({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final Color primaryIconColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
    final Color primaryTextColor = Theme.of(context).colorScheme.onSurface;
    final Color cardColor = Theme.of(context).cardColor;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: primaryIconColor, size: 28),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: primaryIconColor.withOpacity(0.5), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeRow(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final Color primaryIconColor =
            Theme.of(context).colorScheme.onSurface.withOpacity(0.7);
        final Color primaryTextColor = Theme.of(context).colorScheme.onSurface;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Row(
              children: [
                Icon(Icons.dark_mode_outlined,
                    color: primaryIconColor, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    localizations.translate('dark_mode'),
                    style: TextStyle(
                      fontSize: 18,
                      color: primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final Color onBackgroundText = Theme.of(context).colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      // CONDITIONAL RENDERING: Show loading screen if changing language
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  // Assuming 'loading' is a key in your localization files,
                  // or you can hardcode 'Loading...' here
                  Text("Loading..."),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      localizations.translate('account'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onBackgroundText.withOpacity(0.6)),
                    ),
                  ),
                  _buildSettingRow(
                    context: context,
                    title: localizations.translate('profile'),
                    icon: Icons.person_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileDetailScreen()),
                      );
                    },
                  ),
                  _buildSettingRow(
                    context: context,
                    title: localizations.translate('security_privacy'),
                    icon: Icons.security,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PrivacyScreen()),
                      );
                    },
                  ),
                  _buildSettingRow(
                    context: context,
                    title: localizations.translate('language'),
                    icon: Icons.language,
                    onTap: () {
                      _showLanguageSelectionDialog(context, localizations);
                    },
                  ),
                  _buildDarkModeRow(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      localizations.translate('support_feedback'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onBackgroundText.withOpacity(0.6)),
                    ),
                  ),
                  _buildSettingRow(
                    context: context,
                    title: localizations.translate('help_center'),
                    icon: Icons.help_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpCenterScreen()),
                      );
                    },
                  ),
                  _buildSettingRow(
                    context: context,
                    title: localizations.translate('about_us'),
                    icon: Icons.info_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AboutUsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _showLogoutConfirmationDialog(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        localizations.translate('log_out'),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
