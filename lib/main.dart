import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_localizations.dart';
import 'localization/language_controller.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LanguageController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'SEENERGY CAPITAL',
          debugShowCheckedModeBanner: false,
          locale: LanguageController.instance.currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamilyFallback: const [
              'Battambang',
              'Khmer OS',
              'Khmer OS Siemreap',
              'Noto Sans Khmer',
              'sans-serif',
            ],
          ),
          home: const MobileLoginScreen(),
        );
      },
    );
  }
}
