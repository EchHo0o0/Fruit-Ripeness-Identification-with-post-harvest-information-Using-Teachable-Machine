// lib/home/help_center_screen.dart
import 'package:flutter/material.dart';
// Import your AppLocalizations class
import '../home/app_localizations.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for the expansion effect
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the localizations instance
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('help_center')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate(
                  'faq_title'), // Localized: Frequently Asked Questions
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildFAQSection(
              title: localizations.translate(
                  'faq_title_getting_started'), // Localized: Getting Started
              faqs: [
                _buildFAQItem(
                  localizations
                      .translate('faq_q_identify_fruit'), // Localized Q
                  localizations
                      .translate('faq_a_identify_fruit'), // Localized A
                ),
                _buildFAQItem(
                  localizations.translate('faq_q_good_photo'), // Localized Q
                  localizations.translate('faq_a_good_photo'), // Localized A
                ),
              ],
            ),
            _buildFAQSection(
              title: localizations.translate(
                  'faq_title_troubleshooting'), // Localized: Troubleshooting
              faqs: [
                _buildFAQItem(
                  localizations.translate('faq_q_cant_identify'), // Localized Q
                  localizations.translate('faq_a_cant_identify'), // Localized A
                ),
                _buildFAQItem(
                  localizations.translate('faq_q_inaccurate'), // Localized Q
                  localizations.translate('faq_a_inaccurate'), // Localized A
                ),
              ],
            ),
            _buildFAQSection(
              title: localizations
                  .translate('faq_title_features'), // Localized: Features
              faqs: [
                _buildFAQItem(
                  localizations
                      .translate('faq_q_learning_guide'), // Localized Q
                  localizations
                      .translate('faq_a_learning_guide'), // Localized A
                ),
                _buildFAQItem(
                  localizations.translate('faq_q_announcements'), // Localized Q
                  localizations.translate('faq_a_announcements'), // Localized A
                ),
                _buildFAQItem(
                  localizations.translate('faq_q_games'), // Localized Q
                  localizations.translate('faq_a_games'), // Localized A
                ),
                _buildFAQItem(
                  localizations.translate('faq_q_save_list'), // Localized Q
                  localizations.translate('faq_a_save_list'), // Localized A
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              color: Colors.yellow.shade100,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate(
                          'safety_disclaimer_title'), // Localized: Important Safety Disclaimer ⚠️
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      localizations.translate(
                          'safety_disclaimer_content'), // Localized disclaimer content
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... _buildFAQSection and _buildFAQItem methods remain the same ...
  Widget _buildFAQSection({required String title, required List<Widget> faqs}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          ...faqs,
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(top: 8.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
