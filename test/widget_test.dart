import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meals/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that the app builds without throwing any errors
    expect(find.byType(MaterialApp), findsOneWidget);

    // You can add more specific tests here as needed, for example:
    // expect(find.text('Categories'), findsOneWidget);
  });
}
