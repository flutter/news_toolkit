import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    ThemeData? theme,
    MockNavigator? navigator,
  }) async {
    await pumpWidget(
      MaterialApp(
        theme: theme,
        home: navigator == null
            ? Scaffold(
                body: widgetUnderTest,
              )
            : MockNavigatorProvider(
                navigator: navigator,
                child: Scaffold(
                  body: widgetUnderTest,
                ),
              ),
      ),
    );
    await pump();
  }
}
