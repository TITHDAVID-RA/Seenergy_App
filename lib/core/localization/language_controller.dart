import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State management controller for switching and persisting app locale.
class LanguageController extends ChangeNotifier {
  static const String _storageKey = 'app_language_code';

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  String get languageCode => _currentLocale.languageCode;
  bool get isKhmer => _currentLocale.languageCode == 'km';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  LanguageController() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_storageKey);
      if (savedCode != null && (savedCode == 'en' || savedCode == 'km')) {
        _currentLocale = Locale(savedCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to load saved language: $e');
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale.languageCode == newLocale.languageCode) return;
    _currentLocale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, newLocale.languageCode);
    } catch (e) {
      debugPrint('Failed to save language: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final nextLocale = isKhmer ? const Locale('en') : const Locale('km');
    await changeLanguage(nextLocale);
  }
}

