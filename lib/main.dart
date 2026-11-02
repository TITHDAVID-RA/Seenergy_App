import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'app.dart';
import 'core/localization/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
=======
import 'package:flutter_localizations/flutter_localizations.dart';
import 'localization/app_localizations.dart';
import 'localization/language_controller.dart';
import 'screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
>>>>>>> bd071a650e5cb00b29227f7fa6dc30d1eefe24c1

  final languageController = LanguageController();

<<<<<<< HEAD
  runApp(SeenergyApp(languageController: languageController));
=======
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
>>>>>>> bd071a650e5cb00b29227f7fa6dc30d1eefe24c1
}
