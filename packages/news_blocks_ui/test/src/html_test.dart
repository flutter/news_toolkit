// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('Html', () {
    testWidgets('renders HTML text correctly', (tester) async {
      const block = HtmlBlock(content: '<p>Hello</p>');

      await tester.pumpApp(Html(block: block));

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is flutter_html.Html && widget.data == block.content,
        ),
        findsOneWidget,
      );
    });

    group('html style', () {
      testWidgets('styles <p> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<p>Test</p>');

        final theme = AppTheme().themeData;

        await tester.pumpApp(
          MaterialApp(
            theme: theme,
            home: Html(block: block),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is flutter_html.Html &&
                widget.style['p']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(theme.textTheme.bodyText1!)
                        .generateTextStyle(),
          ),
          findsOneWidget,
        );
      });
      testWidgets('styles <h1> tags correctly', (tester) async {});
      testWidgets('styles <h2> tags correctly', (tester) async {});
      testWidgets('styles <h3> tags correctly', (tester) async {});
      testWidgets('styles <h4> tags correctly', (tester) async {});
      testWidgets('styles <h5> tags correctly', (tester) async {});
      testWidgets('styles <h6> tags correctly', (tester) async {});
    });
  });
}
