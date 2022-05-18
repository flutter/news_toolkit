// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NewsletterContainer', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpContentThemedApp(NewsletterContainer());

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is ColoredBox &&
              widget.color == AppColors.secondary.shade800,
        ),
        findsOneWidget,
      );
    });
  });
}
