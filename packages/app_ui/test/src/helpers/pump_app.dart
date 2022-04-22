import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension AppTester on WidgetTester {
  Future<void> pumpApp(Widget widgetUnderTest) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widgetUnderTest,
        ),
      ),
    );
    await pump();
  }
}
