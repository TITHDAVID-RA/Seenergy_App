import 'package:flutter/material.dart';

/// Representation of a supported language in the app.
class AppLanguage {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });

  Locale get locale => Locale(code);

  static const List<AppLanguage> supported = [
    AppLanguage(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇺🇸',
    ),
    AppLanguage(
      code: 'km',
      name: 'Khmer',
      nativeName: 'ភាសាខ្មែរ',
      flag: '🇰🇭',
    ),
  ];

  static AppLanguage fromCode(String code) {
    return supported.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supported.first,
    );
  }
}

