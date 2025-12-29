// lib/home/about_us_screen.dart (Updated to use localization keys)
import 'package:flutter/material.dart';
// 👈 IMPORTANT: Add your AppLocalizations import here
import '../home/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 👈 Get the localizations instance
    final localizations = AppLocalizations.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.translate('about_us')), // Localized
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo
            Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: primaryColor.withOpacity(0.1),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 110,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  localizations.translate('app_slogan'), // Localized
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Mission and Vision Section
            _buildSection(
              context,
              title: localizations
                  .translate('mission_vision_title'), // Localized Title
              body: localizations
                  .translate('mission_vision_body'), // Localized Body
            ),
            const SizedBox(height: 30),

            // How It Works Section
            _buildSection(
              context,
              title: localizations
                  .translate('how_it_works_title'), // Localized Title
              body: localizations
                  .translate('how_it_works_body'), // Localized Body
            ),
            const SizedBox(height: 30),

            // Team Information
            _buildTeamSection(context),

            const SizedBox(height: 30),

            // Contact Information
            _buildSection(
              context,
              title: localizations
                  .translate('contact_us_title'), // Localized Title
              body:
                  localizations.translate('contact_us_body'), // Localized Body
            ),
          ],
        ),
      ),
    );
  }

  // Helper method updated to take localized strings as arguments
  Widget _buildSection(BuildContext context,
      {required String title, required String body}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.translate('team_title'), // Localized Title
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildTeamMember(
                context,
                localizations.translate('role_developers'), // Localized Role
                'Jerico R. Infante, Gillian P. Bernal, Reame A. Lacaran'),
            _buildTeamMember(
                context,
                localizations.translate('role_adviser'), // Localized Role
                'Ricky Jay Riel'),
            _buildTeamMember(
                context,
                localizations
                    .translate('role_technical_critique'), // Localized Role
                'Kimberly Bautista'),
          ],
        ),
      ),
    );
  }

  // Helper method updated to take localized role strings as arguments
  Widget _buildTeamMember(BuildContext context, String role, String names) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            role,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            names,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
