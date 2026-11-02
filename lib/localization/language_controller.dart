import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global controller to manage and persist the selected app language.
class LanguageController extends ChangeNotifier {
  static const String _prefKey = 'selected_language';

  static final LanguageController instance = LanguageController._internal();

  LanguageController._internal() {
    loadSavedLanguage();
  }

  factory LanguageController() => instance;

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;
  String get languageCode => _currentLocale.languageCode;
  bool get isKhmer => _currentLocale.languageCode == 'km';
  bool get isEnglish => _currentLocale.languageCode == 'en';

  Future<void> loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code == 'km' || code == 'en') {
        _currentLocale = Locale(code!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode == languageCode) return;
    _currentLocale = Locale(languageCode);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, languageCode);
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  Future<void> toggleLanguage() async {
    final nextCode = isKhmer ? 'en' : 'km';
    await changeLanguage(nextCode);
  }
}

