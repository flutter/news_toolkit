// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AppSwitch', () {
    testWidgets(
        'renders onText '
        'when enabled', (tester) async {
      await tester.pumpApp(
        AppSwitch(
          value: true,
          onText: 'On',
          onChanged: (_) {},
        ),
      );

      expect(find.text('On'), findsOneWidget);
    });

    testWidgets(
        'renders offText '
        'when disabled', (tester) async {
      await tester.pumpApp(
        AppSwitch(
          value: false,
          offText: 'Off',
          onChanged: (_) {},
        ),
      );

      expect(find.text('Off'), findsOneWidget);
    });

    testWidgets('renders Switch', (tester) async {
      await tester.pumpApp(
        AppSwitch(
          value: true,
          onChanged: (_) {},
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Switch && widget.value == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        AppSwitch(
          value: true,
          onChanged: (_) => tapped = true,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
