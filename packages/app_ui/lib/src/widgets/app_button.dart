import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  const AppButton._({
    Key? key,
    required this.child,
    this.onPressed,
    Color? buttonColor,
    Color? foregroundColor,
    BorderSide? borderSide,
    double? elevation,
    TextStyle? textStyle,
    Size? maximumSize,
    EdgeInsets? padding,
  })  : _buttonColor = buttonColor ?? Colors.white,
        _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _elevation = elevation ?? 0,
        _textStyle = textStyle,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _padding = padding ?? _defaultPadding,
        super(key: key);

  /// Filled black button.
  const AppButton.black({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.black,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled blue dress button.
  const AppButton.blueDress({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.blueDress,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled crystal blue button.
  const AppButton.crystalBlue({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.crystalBlue,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled red wine button.
  const AppButton.redWine({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.redWine,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Filled dark aqua button.
  const AppButton.darkAqua({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.darkAqua,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          textStyle: textStyle,
        );

  /// Outlined transparent button.
  const AppButton.outlinedTransparent({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.transparent,
          borderSide: const BorderSide(
            color: AppColors.paleSky,
          ),
          elevation: elevation,
          foregroundColor: AppColors.darkAqua,
          textStyle: textStyle,
        );

  /// Outlined white button.
  const AppButton.outlinedWhite({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    TextStyle? textStyle,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          child: child,
          buttonColor: AppColors.white,
          borderSide: const BorderSide(
            color: AppColors.pastelGrey,
          ),
          elevation: elevation,
          foregroundColor: AppColors.lightBlack,
          textStyle: textStyle,
        );

  /// Filled small red wine blue button.
  const AppButton.smallRedWine({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.redWine,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          padding: _smallPadding,
        );

  /// Filled small transparent button.
  const AppButton.smallTransparent({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.transparent,
          child: child,
          foregroundColor: AppColors.liver,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          padding: _smallPadding,
        );

  /// Filled small transparent button.
  const AppButton.smallOutlineTransparent({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.transparent,
          child: child,
          borderSide: const BorderSide(
            color: AppColors.paleSky,
          ),
          foregroundColor: AppColors.darkAqua,
          elevation: elevation,
          maximumSize: _smallMaximumSize,
          padding: _smallPadding,
        );

  /// The maximum size of the small variant of the button.
  static const _smallMaximumSize = Size(double.infinity, 40);

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.infinity, 56);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(double.infinity, 40);

  /// The padding of the small variant of the button.
  static const _smallPadding = EdgeInsets.zero;

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.symmetric(vertical: 16);

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// A background color of the button.
  ///
  /// Defaults to [Colors.white].
  final Color _buttonColor;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [AppColors.black].
  final Color _foregroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// Elevation of the button.
  final double _elevation;

  /// [TextStyle] of the button text.
  ///
  /// Defaults to [TextTheme.button].
  final TextStyle? _textStyle;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size _maximumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets _padding;

  /// [Widget] displayed on the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle ?? Theme.of(context).textTheme.button;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(_maximumSize),
        padding: MaterialStateProperty.all(_padding),
        minimumSize: MaterialStateProperty.all(_defaultMinimumSize),
        textStyle: MaterialStateProperty.all(textStyle),
        backgroundColor: onPressed == null
            ? MaterialStateProperty.all(AppColors.black.withOpacity(.12))
            : MaterialStateProperty.all(_buttonColor),
        elevation: MaterialStateProperty.all(_elevation),
        foregroundColor: onPressed == null
            ? MaterialStateProperty.all(AppColors.rangoonGreen.withOpacity(.38))
            : MaterialStateProperty.all(_foregroundColor),
        side: MaterialStateProperty.all(_borderSide),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: child,
    );
  }
}
