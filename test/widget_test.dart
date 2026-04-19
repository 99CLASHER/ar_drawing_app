// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ar_drawing_app/main.dart';
import 'package:ar_drawing_app/core/di/service_locator.dart';

void main() {
  // Initialize dependencies before building the app
  setUpAll(() async {
    await initializeDependencies();
  });

  testWidgets('AR Drawing App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ARDrawingApp(),
      ),
    );

    // Verify that app builds without crashing
    expect(tester.takeException(), isNull);
  });
}
