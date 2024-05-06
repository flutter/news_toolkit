// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;
import 'package:flutter_test/flutter_test.dart';
import 'package:html/dom.dart' as dom;
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _FakeLaunchOptions extends Fake implements LaunchOptions {}

class _MockDomElement extends Mock implements dom.Element {}

void main() {
  group('Html', () {
    late UrlLauncherPlatform urlLauncher;
    final domElement = _MockDomElement();

    setUpAll(() {
      registerFallbackValue(_FakeLaunchOptions());
    });

    setUp(() {
      urlLauncher = _MockUrlLauncher();
      UrlLauncherPlatform.instance = urlLauncher;
    });

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

    group('hyperlinks', () {
      testWidgets('does not launch the url when it is null', (tester) async {
        const String? link = null;
        const block = HtmlBlock(
          content: '<a href="$link">flutter.dev</a>',
        );

        await tester.pumpApp(Html(block: block));

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;

        // workaround as taping a elements is not working.
        widget.onLinkTap!(link, {}, domElement);

        verifyNever(() => urlLauncher.launchUrl(any(), any()));
      });

      testWidgets('does not launch the url when it is invalid', (tester) async {
        const link = '::Not valid URI::';
        const block = HtmlBlock(
          content: '<a href="$link">flutter.dev</a>',
        );

        await tester.pumpApp(Html(block: block));

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;

        // workaround as taping a elements is not working.
        widget.onLinkTap!(link, {}, domElement);

        verifyNever(() => urlLauncher.launchUrl(any(), any()));
      });

      testWidgets('launches the url when it is a valid url', (tester) async {
        const link = 'https://flutter.dev';
        const block = HtmlBlock(
          content: '<a href="$link">flutter.dev</a>',
        );

        await tester.pumpApp(Html(block: block));

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;

        // workaround as taping a elements is not working.
        widget.onLinkTap!(link, {}, domElement);

        verify(
          () => urlLauncher.launchUrl('https://flutter.dev', any()),
        ).called(1);
      });
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.displayLarge!.copyWith(letterSpacing: -0.25),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h1']!.generateTextStyle();

        expect(style, expectedStyle);
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.displayMedium!.copyWith(letterSpacing: 0),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h2']!.generateTextStyle();

        expect(style, expectedStyle);
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.displaySmall!.copyWith(letterSpacing: 0),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h3']!.generateTextStyle();

        expect(style, expectedStyle);
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.headlineMedium!.copyWith(letterSpacing: 0),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h4']!.generateTextStyle();

        expect(style, expectedStyle);
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.headlineSmall!.copyWith(letterSpacing: 0),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h5']!.generateTextStyle();

        expect(style, expectedStyle);
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

        final expectedStyle = flutter_html.Style.fromTextStyle(
          theme.textTheme.titleLarge!.copyWith(letterSpacing: 0),
        ).generateTextStyle();

        final widget =
            tester.widget(find.byType(flutter_html.Html)) as flutter_html.Html;
        final style = widget.style['h6']!.generateTextStyle();

        expect(style, expectedStyle);
      });
    });
  });
}
