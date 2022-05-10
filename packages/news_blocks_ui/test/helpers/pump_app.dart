import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    ThemeData? theme,
  }) async {
    await pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: widgetUnderTest,
        ),
      ),
    );
    await pump();
  }
}
