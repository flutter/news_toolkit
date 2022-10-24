import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension AppContentThemedTester on WidgetTester {
  Future<void> pumpContentThemedApp(Widget widgetUnderTest) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: ContentThemeOverrideBuilder(
              builder: (context) => widgetUnderTest,
            ),
          ),
        ),
      ),
    );
    await pump();
  }
}
