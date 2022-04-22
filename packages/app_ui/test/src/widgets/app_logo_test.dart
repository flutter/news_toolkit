import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppLogo', () {
    testWidgets(
        'renders dark logo '
        'for AppLogo.dark', (tester) async {
      await tester.pumpApp(AppLogo.dark());

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image == Assets.images.logoDark &&
              widget.width == 172,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders light logo '
        'for AppLogo.light', (tester) async {
      await tester.pumpApp(AppLogo.light());

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image == Assets.images.logoLight &&
              widget.width == 172,
        ),
        findsOneWidget,
      );
    });
  });
}
