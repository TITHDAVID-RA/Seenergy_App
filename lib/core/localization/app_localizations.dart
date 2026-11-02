import 'package:flutter/material.dart';

/// AppLocalizations handles bilingual support (Khmer and English).
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'brandName': 'SEENERGY',
      'brandSubtitle': 'CAPITAL',
      'signInTitle': 'Sign In',
      'signInSubtitle': 'Welcome back! Enter your details to continue.',
      'emailLabel': 'EMAIL ADDRESS *',
      'emailHint': 'Email Address',
      'passwordLabel': 'PASSWORD *',
      'passwordHint': 'Password',
      'logInButton': 'Log In',
      'protectedBy': 'Protected by Enterprise Security',
      'copyright': '© SEENERGY CAPITAL. All rights reserved.',
      'language': 'Language',
      'english': 'English',
      'khmer': 'ភាសាខ្មែរ',
      'switchLanguage': 'Switch Language',
      'selectLanguage': 'Select Language',
    },
    'km': {
      'brandName': 'SEENERGY',
      'brandSubtitle': 'CAPITAL',
      'signInTitle': 'ចូលគណនី',
      'signInSubtitle': 'សូមស្វាគមន៍ត្រឡប់មកវិញ! សូមបញ្ចូលព័ត៌មានរបស់អ្នកដើម្បីបន្ត។',
      'emailLabel': 'អាសយដ្ឋានអ៊ីមែល *',
      'emailHint': 'បញ្ចូលអាសយដ្ឋានអ៊ីមែល',
      'passwordLabel': 'ពាក្យសម្ងាត់ *',
      'passwordHint': 'បញ្ចូលពាក្យសម្ងាត់',
      'logInButton': 'ចូលគណនី',
      'protectedBy': 'ការពារដោយប្រព័ន្ធសុវត្ថិភាពកម្រិតសហគ្រាស',
      'copyright': '© SEENERGY CAPITAL. រក្សាសិទ្ធិគ្រប់យ៉ាង។',
      'language': 'ភាសា',
      'english': 'English',
      'khmer': 'ភាសាខ្មែរ',
      'switchLanguage': 'ប្តូរភាសា',
      'selectLanguage': 'ជ្រើសរើសភាសា',
    },
  };

  String _get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Getters for typed access
  String get brandName => _get('brandName');
  String get brandSubtitle => _get('brandSubtitle');
  String get signInTitle => _get('signInTitle');
  String get signInSubtitle => _get('signInSubtitle');
  String get emailLabel => _get('emailLabel');
  String get emailHint => _get('emailHint');
  String get passwordLabel => _get('passwordLabel');
  String get passwordHint => _get('passwordHint');
  String get logInButton => _get('logInButton');
  String get protectedBy => _get('protectedBy');
  String get copyright => _get('copyright');
  String get language => _get('language');
  String get english => _get('english');
  String get khmer => _get('khmer');
  String get switchLanguage => _get('switchLanguage');
  String get selectLanguage => _get('selectLanguage');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'km'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

