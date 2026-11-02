import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seenergy_capital/localization/language_controller.dart';
import 'package:seenergy_capital/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LanguageController.instance.changeLanguage('en');
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

    // Verify Khmer strings
    expect(find.text('ចូលគណនី'), findsWidgets);
    expect(find.text('អាសយដ្ឋានអ៊ីមែល *'), findsOneWidget);
  });

  testWidgets('Logs in with test credentials and navigates to HRMS Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Find and tap the Log In button
    final loginButton = find.text('Log In');
    expect(loginButton, findsOneWidget);
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);

    // Process the simulated network authentication delay
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();

    // Verify HRMS Dashboard elements
    expect(find.text('HRMS'), findsOneWidget);
    expect(find.text('Overview Today'), findsOneWidget);
    expect(find.text('Total Staff'), findsOneWidget);
  });
}
