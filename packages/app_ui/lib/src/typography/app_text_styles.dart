import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

/// App Text Style Definitions
abstract class AppTextStyle {
  static const _baseTextStyle = TextStyle(
    fontWeight: AppFontWeight.regular,
    height: 1.5,
    package: 'app_ui',
    fontFamily: 'Futura',
  );

  /// Headline 1 Text Style
  static final TextStyle headline1 = _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: AppFontWeight.bold,
    height: 1.25,
  );

  /// Headline 2 Text Style
  static final TextStyle headline2 = _baseTextStyle.copyWith(
    fontSize: 26,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 3 Text Style
  static final TextStyle headline3 = _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 4 Text Style
  static final TextStyle headline4 = _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 5 Text Style
  static final TextStyle headline5 = _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: AppFontWeight.extraBold,
    height: 1.25,
  );

  /// Headline 6 Text Style
  static final TextStyle headline6 = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: AppFontWeight.bold,
    height: 1.25,
  );

  /// Subtitle 1 Text Style
  static final TextStyle subtitle1 = _baseTextStyle.copyWith(
    fontSize: 16,
  );

  /// Subtitle 2 Text Style
  static final TextStyle subtitle2 = _baseTextStyle.copyWith(
    fontSize: 14,
  );

  /// Body Text 1 Text Style
  static final TextStyle bodyText1 = _baseTextStyle.copyWith(
    fontSize: 14,
  );

  /// Body Text 2 Text Style (the default)
  static final TextStyle bodyText2 = _baseTextStyle.copyWith(
    fontSize: 16,
  );

  /// Button Text Style
  static final TextStyle button = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: AppFontWeight.bold,
  );

  /// Caption Text Style
  static final TextStyle caption = _baseTextStyle.copyWith(
    fontSize: 12,
  );

  /// Overline Text Style
  static final TextStyle overline = _baseTextStyle.copyWith(
    fontSize: 10,
    fontWeight: AppFontWeight.medium,
  );
}
