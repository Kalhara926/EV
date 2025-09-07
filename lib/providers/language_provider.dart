// lib/providers/language_provider.dart

import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // Default language is English

  Locale get locale => _locale;

  void changeLanguage(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }
}
