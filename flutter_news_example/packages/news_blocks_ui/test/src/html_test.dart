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

    group('styles', () {
      testWidgets('<p> tags correctly', (tester) async {
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
                    flutter_html.Style.fromTextStyle(theme.textTheme.bodyLarge!)
                        .generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h1> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h1>Test</h1>');

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
                widget.style['h1']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.displayLarge!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h2> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h2>Test</h2>');

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
                widget.style['h2']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.displayMedium!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h3> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h3>Test</h3>');

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
                widget.style['h3']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.displaySmall!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h4> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h4>Test</h4>');

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
                widget.style['h4']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.headlineMedium!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h5> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h5>Test</h5>');

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
                widget.style['h5']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.headlineSmall!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });

      testWidgets('<h6> tags correctly', (tester) async {
        const block = HtmlBlock(content: '<h6>Test</h6>');

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
                widget.style['h6']!.generateTextStyle() ==
                    flutter_html.Style.fromTextStyle(
                      theme.textTheme.titleLarge!,
                    ).generateTextStyle(),
          ),
          findsOneWidget,
        );
      });
    });
  });
}
