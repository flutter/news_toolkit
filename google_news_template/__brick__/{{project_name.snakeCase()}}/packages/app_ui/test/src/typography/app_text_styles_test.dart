import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextStyles', () {
    group('UITextStyle', () {
      test('display2 returns TextStyle', () {
        expect(UITextStyle.display2, isA<TextStyle>());
      });

      test('display3 returns TextStyle', () {
        expect(UITextStyle.display3, isA<TextStyle>());
      });

      test('headline1 returns TextStyle', () {
        expect(UITextStyle.headline1, isA<TextStyle>());
      });

      test('headline2 returns TextStyle', () {
        expect(UITextStyle.headline2, isA<TextStyle>());
      });

      test('headline3 returns TextStyle', () {
        expect(UITextStyle.headline3, isA<TextStyle>());
      });

      test('headline4 returns TextStyle', () {
        expect(UITextStyle.headline4, isA<TextStyle>());
      });

      test('headline5 returns TextStyle', () {
        expect(UITextStyle.headline5, isA<TextStyle>());
      });

      test('headline6 returns TextStyle', () {
        expect(UITextStyle.headline6, isA<TextStyle>());
      });

      test('subtitle1 returns TextStyle', () {
        expect(UITextStyle.subtitle1, isA<TextStyle>());
      });

      test('subtitle2 returns TextStyle', () {
        expect(UITextStyle.subtitle2, isA<TextStyle>());
      });

      test('bodyText1 returns TextStyle', () {
        expect(UITextStyle.bodyText1, isA<TextStyle>());
      });

      test('bodyText2 returns TextStyle', () {
        expect(UITextStyle.bodyText2, isA<TextStyle>());
      });

      test('button returns TextStyle', () {
        expect(UITextStyle.button, isA<TextStyle>());
      });

      test('caption returns TextStyle', () {
        expect(UITextStyle.caption, isA<TextStyle>());
      });

      test('overline returns TextStyle', () {
        expect(UITextStyle.overline, isA<TextStyle>());
      });

      test('labelSmall returns TextStyle', () {
        expect(UITextStyle.labelSmall, isA<TextStyle>());
      });
    });

    group('ContentTextStyle', () {
      test('display1 returns TextStyle', () {
        expect(ContentTextStyle.display1, isA<TextStyle>());
      });

      test('display2 returns TextStyle', () {
        expect(ContentTextStyle.display2, isA<TextStyle>());
      });

      test('display3 returns TextStyle', () {
        expect(ContentTextStyle.display3, isA<TextStyle>());
      });

      test('headline1 returns TextStyle', () {
        expect(ContentTextStyle.headline1, isA<TextStyle>());
      });

      test('headline2 returns TextStyle', () {
        expect(ContentTextStyle.headline2, isA<TextStyle>());
      });

      test('headline3 returns TextStyle', () {
        expect(ContentTextStyle.headline3, isA<TextStyle>());
      });

      test('headline4 returns TextStyle', () {
        expect(ContentTextStyle.headline4, isA<TextStyle>());
      });

      test('headline5 returns TextStyle', () {
        expect(ContentTextStyle.headline5, isA<TextStyle>());
      });

      test('headline6 returns TextStyle', () {
        expect(ContentTextStyle.headline6, isA<TextStyle>());
      });

      test('subtitle1 returns TextStyle', () {
        expect(ContentTextStyle.subtitle1, isA<TextStyle>());
      });

      test('subtitle2 returns TextStyle', () {
        expect(ContentTextStyle.subtitle2, isA<TextStyle>());
      });

      test('bodyText1 returns TextStyle', () {
        expect(ContentTextStyle.bodyText1, isA<TextStyle>());
      });

      test('bodyText2 returns TextStyle', () {
        expect(ContentTextStyle.bodyText2, isA<TextStyle>());
      });

      test('button returns TextStyle', () {
        expect(ContentTextStyle.button, isA<TextStyle>());
      });

      test('caption returns TextStyle', () {
        expect(ContentTextStyle.caption, isA<TextStyle>());
      });

      test('overline returns TextStyle', () {
        expect(ContentTextStyle.overline, isA<TextStyle>());
      });

      test('labelSmall returns TextStyle', () {
        expect(ContentTextStyle.labelSmall, isA<TextStyle>());
      });
    });
  });
}
