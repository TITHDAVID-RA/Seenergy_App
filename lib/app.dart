import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/language_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';

/// Root Application Widget configuring theme and bilingual localization.
class SeenergyApp extends StatelessWidget {
  final LanguageController languageController;

  const SeenergyApp({super.key, required this.languageController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: languageController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Seenergy Capital',
          debugShowCheckedModeBanner: true,
          theme: AppTheme.lightTheme,
          locale: languageController.currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: LoginScreen(languageController: languageController),
        );
      },
    );
  }
}
