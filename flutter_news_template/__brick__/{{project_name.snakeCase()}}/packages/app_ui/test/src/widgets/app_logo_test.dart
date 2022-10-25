import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppLogo', () {
    testWidgets('renders Image for AppLogo.dark', (tester) async {
      await tester.pumpApp(AppLogo.dark());

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Image && widget.width == 172,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders Image for AppLogo.light', (tester) async {
      await tester.pumpApp(AppLogo.light());

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Image && widget.width == 172,
        ),
        findsOneWidget,
      );
    });
  });
}
