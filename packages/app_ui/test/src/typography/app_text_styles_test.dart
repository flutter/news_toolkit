import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTextStyles', () {
    test('display1 returns TextStyle', () {
      expect(AppTextStyle.display1, isA<TextStyle>());
    });

    test('display2 returns TextStyle', () {
      expect(AppTextStyle.display2, isA<TextStyle>());
    });

    test('display3 returns TextStyle', () {
      expect(AppTextStyle.display3, isA<TextStyle>());
    });

    test('headline1 returns TextStyle', () {
      expect(AppTextStyle.headline1, isA<TextStyle>());
    });

    test('headline2 returns TextStyle', () {
      expect(AppTextStyle.headline2, isA<TextStyle>());
    });

    test('headline3 returns TextStyle', () {
      expect(AppTextStyle.headline3, isA<TextStyle>());
    });

    test('headline4 returns TextStyle', () {
      expect(AppTextStyle.headline4, isA<TextStyle>());
    });

    test('headline5 returns TextStyle', () {
      expect(AppTextStyle.headline5, isA<TextStyle>());
    });

    test('headline6 returns TextStyle', () {
      expect(AppTextStyle.headline6, isA<TextStyle>());
    });

    test('subtitle1 returns TextStyle', () {
      expect(AppTextStyle.subtitle1, isA<TextStyle>());
    });

    test('subtitle2 returns TextStyle', () {
      expect(AppTextStyle.subtitle2, isA<TextStyle>());
    });

    test('bodyText1 returns TextStyle', () {
      expect(AppTextStyle.bodyText1, isA<TextStyle>());
    });

    test('bodyText2 returns TextStyle', () {
      expect(AppTextStyle.bodyText2, isA<TextStyle>());
    });

    test('button returns TextStyle', () {
      expect(AppTextStyle.button, isA<TextStyle>());
    });

    test('caption returns TextStyle', () {
      expect(AppTextStyle.caption, isA<TextStyle>());
    });

    test('overline returns TextStyle', () {
      expect(AppTextStyle.overline, isA<TextStyle>());
    });

    test('labelSmall returns TextStyle', () {
      expect(AppTextStyle.labelSmall, isA<TextStyle>());
    });
  });
}
