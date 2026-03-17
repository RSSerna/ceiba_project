// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ceiba_project/main.dart';

void main() {
  testWidgets('App starts and shows balance header', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CeibaApp());

    // The app should show a balance header when it starts.
    expect(find.textContaining('Saldo'), findsOneWidget);
  });
}
