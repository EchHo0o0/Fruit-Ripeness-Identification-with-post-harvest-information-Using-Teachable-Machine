// language_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Default to English

  Locale get locale => _locale;

  LanguageProvider() {
    _loadPreferredLanguage();
  }

  // Load saved preference from local storage
  void _loadPreferredLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  // Change the language and save the preference
  void setLocale(Locale newLocale) async {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);
    }
  }

  // Helper to determine if the current locale is Tagalog
  bool get isTagalog => _locale.languageCode == 'tl';
}
