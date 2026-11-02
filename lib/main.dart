import 'package:flutter/material.dart';
import 'app.dart';
import 'core/localization/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final languageController = LanguageController();

  runApp(SeenergyApp(languageController: languageController));
}
