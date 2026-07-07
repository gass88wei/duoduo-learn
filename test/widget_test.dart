import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dlg_q/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DIYDuolingoApp()));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('学习'), findsWidgets);
  });
}
