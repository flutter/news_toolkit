// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ArticleThemeOverride', () {
    testWidgets('renders ContentThemeOverrideBuilder', (tester) async {
      await tester.pumpApp(
        ArticleThemeOverride(
          isVideoArticle: false,
          child: SizedBox(),
        ),
      );

      expect(find.byType(ContentThemeOverrideBuilder), findsOneWidget);
    });

    testWidgets('provides ArticleThemeColors', (tester) async {
      late ArticleThemeColors colors;
      await tester.pumpApp(
        ArticleThemeOverride(
          isVideoArticle: false,
          child: Builder(
            builder: (context) {
              colors = Theme.of(context).extension<ArticleThemeColors>()!;
              return SizedBox();
            },
          ),
        ),
      );

      expect(colors, isNotNull);
    });

    testWidgets('renders child', (tester) async {
      final childKey = Key('__child__');

      await tester.pumpApp(
        ArticleThemeOverride(
          isVideoArticle: false,
          child: SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });
  });

  group('ArticleThemeColors', () {
    test('supports value comparisons', () {
      expect(
        ArticleThemeColors(
          captionNormal: Colors.black,
          captionLight: Colors.black,
        ),
        equals(
          ArticleThemeColors(
            captionNormal: Colors.black,
            captionLight: Colors.black,
          ),
        ),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          ArticleThemeColors(
            captionNormal: Colors.black,
            captionLight: Colors.black,
          ).copyWith(),
          equals(
            ArticleThemeColors(
              captionNormal: Colors.black,
              captionLight: Colors.black,
            ),
          ),
        );
      });

      test(
          'returns object with updated captionNormal '
          'when captionNormal is passed', () {
        expect(
          ArticleThemeColors(
            captionNormal: Colors.black,
            captionLight: Colors.black,
          ).copyWith(captionNormal: Colors.white),
          equals(
            ArticleThemeColors(
              captionNormal: Colors.white,
              captionLight: Colors.black,
            ),
          ),
        );
      });

      test(
          'returns object with updated captionLight '
          'when captionLight is passed', () {
        expect(
          ArticleThemeColors(
            captionNormal: Colors.black,
            captionLight: Colors.black,
          ).copyWith(captionLight: Colors.white),
          equals(
            ArticleThemeColors(
              captionNormal: Colors.black,
              captionLight: Colors.white,
            ),
          ),
        );
      });
    });

    group('lerp', () {
      test(
          'returns same object '
          'when other is null', () {
        expect(
          ArticleThemeColors(
            captionNormal: Colors.black,
            captionLight: Colors.black,
          ).lerp(null, 0.5),
          equals(
            ArticleThemeColors(
              captionNormal: Colors.black,
              captionLight: Colors.black,
            ),
          ),
        );
      });

      test(
          'returns object '
          'with interpolated colors '
          'when other is passed', () {
        const colorA = Colors.black;
        const colorB = Colors.white;
        const t = 0.5;

        expect(
          ArticleThemeColors(
            captionNormal: colorA,
            captionLight: colorA,
          ).lerp(
            ArticleThemeColors(
              captionNormal: colorB,
              captionLight: colorB,
            ),
            t,
          ),
          equals(
            ArticleThemeColors(
              captionNormal: Color.lerp(colorA, colorB, 0.5)!,
              captionLight: Color.lerp(colorA, colorB, 0.5)!,
            ),
          ),
        );
      });
    });
  });
}
