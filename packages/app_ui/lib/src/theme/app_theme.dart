import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      primaryColor: AppColors.blue,
      canvasColor: _backgroundColor,
      backgroundColor: _backgroundColor,
      scaffoldBackgroundColor: _backgroundColor,
      iconTheme: _iconTheme,
      appBarTheme: _appBarTheme,
      dividerTheme: _dividerTheme,
      textTheme: _textTheme,
      inputDecorationTheme: _inputDecorationTheme,
      buttonTheme: _buttonTheme,
      splashColor: AppColors.transparent,
      snackBarTheme: _snackBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      colorScheme: _colorScheme,
      bottomSheetTheme: _bottomSheetTheme,
    );
  }

  ColorScheme get _colorScheme {
    return ColorScheme.light(secondary: AppColors.lightBlue.shade300);
  }

  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: AppTextStyle.bodyText1.copyWith(
        color: AppColors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.black,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  Color get _backgroundColor => AppColors.white;

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      iconTheme: _iconTheme,
      titleTextStyle: _textTheme.headline6,
      elevation: 0,
      backgroundColor: AppColors.transparent,
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(
      color: AppColors.onBackground,
    );
  }

  DividerThemeData get _dividerTheme {
    return DividerThemeData(
      color: AppColors.grey.shade200,
      space: AppSpacing.xxxs,
      thickness: AppSpacing.xxxs,
      indent: 56,
      endIndent: AppSpacing.lg,
    );
  }

  TextTheme get _textTheme {
    return TextTheme(
      headline1: AppTextStyle.headline1,
      headline2: AppTextStyle.headline2,
      headline3: AppTextStyle.headline3,
      headline4: AppTextStyle.headline4,
      headline5: AppTextStyle.headline5,
      headline6: AppTextStyle.headline6,
      subtitle1: AppTextStyle.subtitle1,
      subtitle2: AppTextStyle.subtitle2,
      bodyText1: AppTextStyle.bodyText1,
      bodyText2: AppTextStyle.bodyText2,
      button: AppTextStyle.button,
      caption: AppTextStyle.caption,
      overline: AppTextStyle.overline,
    ).apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
      decorationColor: AppColors.black,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      suffixIconColor: AppColors.mediumEmphasis,
      prefixIconColor: AppColors.mediumEmphasis,
      enabledBorder: _textFieldBorder,
      focusedBorder: _textFieldBorder,
      disabledBorder: _textFieldBorder,
      hintStyle: AppTextStyle.bodyText1.copyWith(
        color: AppColors.mediumEmphasis,
      ),
      border: const UnderlineInputBorder(),
      filled: true,
      isDense: true,
      errorStyle: AppTextStyle.caption,
    );
  }

  ButtonThemeData get _buttonTheme {
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        textStyle: _textTheme.button,
        primary: AppColors.blue,
      ),
    );
  }

  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.button?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        primary: AppColors.black,
      ),
    );
  }

  BottomSheetThemeData get _bottomSheetTheme {
    return const BottomSheetThemeData(
      backgroundColor: AppColors.modalBackground,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.lg),
          topRight: Radius.circular(AppSpacing.lg),
        ),
      ),
    );
  }
}

InputBorder get _textFieldBorder => const UnderlineInputBorder(
      borderSide: BorderSide(
        width: 1.5,
        color: AppColors.darkAqua,
      ),
    );

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ColorScheme get _colorScheme {
    return const ColorScheme.dark().copyWith(
      primary: AppColors.white,
      secondary: AppColors.lightBlue.shade300,
    );
  }

  @override
  TextTheme get _textTheme {
    return super._textTheme.apply(
          bodyColor: AppColors.white,
          displayColor: AppColors.white,
          decorationColor: AppColors.white,
        );
  }

  @override
  SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      contentTextStyle: AppTextStyle.bodyText1.copyWith(
        color: AppColors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      actionTextColor: AppColors.lightBlue.shade300,
      backgroundColor: AppColors.grey.shade300,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
    );
  }

  @override
  TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: _textTheme.button?.copyWith(
          fontWeight: AppFontWeight.light,
        ),
        primary: AppColors.white,
      ),
    );
  }

  @override
  Color get _backgroundColor => AppColors.grey.shade900;

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(color: AppColors.white);
  }

  @override
  DividerThemeData get _dividerTheme {
    return DividerThemeData(
      color: AppColors.darkOnBackground.withOpacity(0.16),
      space: AppSpacing.lg,
      thickness: AppSpacing.xxxs,
      indent: 0,
      endIndent: 0,
    );
  }
}
