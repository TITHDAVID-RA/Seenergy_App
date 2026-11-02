import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
import 'package:seenergy_capital/app.dart';
import 'package:seenergy_capital/core/localization/language_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders login screen and switches language to Khmer', (WidgetTester tester) async {
    final languageController = LanguageController();

    await tester.pumpWidget(SeenergyApp(languageController: languageController));
    await tester.pumpAndSettle();

    // Verify default English strings
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('EMAIL ADDRESS *'), findsOneWidget);

    // Switch to Khmer
    await tester.tap(find.text('KM'));
    await tester.pumpAndSettle();

=======
import 'package:seenergy_capital/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App renders login screen and switches language to Khmer', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify default English strings
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('EMAIL ADDRESS *'), findsOneWidget);

    // Switch to Khmer
    await tester.tap(find.text('ខ្មែរ'));
    await tester.pumpAndSettle();

>>>>>>> bd071a650e5cb00b29227f7fa6dc30d1eefe24c1
    // Verify Khmer strings
    expect(find.text('ចូលគណនី'), findsWidgets);
    expect(find.text('អាសយដ្ឋានអ៊ីមែល *'), findsOneWidget);
  });
}
