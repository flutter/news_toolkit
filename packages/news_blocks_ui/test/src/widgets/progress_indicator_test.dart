// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ProgressIndicator', () {
    testWidgets('renders ColoredBox with gainsboro color', (tester) async {
      await tester.pumpApp(
        ProgressIndicator(progress: 0.5),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox && widget.color == AppColors.gainsboro,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders CircularProgressIndicator', (tester) async {
      const progress = 0.5;

      await tester.pumpApp(
        ProgressIndicator(progress: progress),
      );

      expect(
        find.descendant(
          of: find.byType(ColoredBox),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is CircularProgressIndicator && widget.value == progress,
          ),
        ),
        findsOneWidget,
      );
    });
  });
}
