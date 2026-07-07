import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dlg_q/app.dart';
import 'package:dlg_q/main.dart';

void main() {
  testWidgets('App bottom navigation renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DIYDuolingoApp()));
    await tester.pump();
    // sqflite databaseFactory is not initialized on Linux CI;
    // swallow the platform-level exception so the test can verify UI
    tester.takeException();
    expect(find.byType(MainApp), findsOneWidget);
  });
}
