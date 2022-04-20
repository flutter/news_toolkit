import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class AppButton extends StatelessWidget {
  /// {@macro app_button}
  AppButton._({
    Key? key,
    required this.child,
    this.onPressed,
    Color? buttonColor,
    Color? foregroundColor,
    BorderSide? borderSide,
    double? elevation,
    TextStyle? textStyle,
  })  : _buttonColor = buttonColor ?? Colors.white,
        _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _elevation = elevation ?? 0,
        _textStyle = textStyle ?? AppTextStyle.button,
        super(key: key);

  /// Filled black button.
  AppButton.black({
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
  AppButton.blueDress({
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
  AppButton.crystalBlue({
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
  AppButton.redWine({
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
  AppButton.darkAqua({
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
  AppButton.outlinedTransparent({
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
  AppButton.outlinedWhite({
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
  AppButton.smallRedWine({
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
          textStyle: AppTextStyle.smallButton,
        );

  /// Filled small transparent button.
  AppButton.smallTransparent({
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
          textStyle: AppTextStyle.smallButton,
        );

  /// Filled small transparent button.
  AppButton.smallOutlineTransparent({
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
          textStyle: AppTextStyle.smallButton,
        );

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// A background color of the button.
  final Color _buttonColor;

  /// Color of the text, icons etc.
  final Color _foregroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// Elevation of the button.
  final double _elevation;

  /// [TextStyle] of the button text.
  final TextStyle _textStyle;

  /// [Widget] displayed on the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(
          Size(
            double.infinity,
            _textStyle == AppTextStyle.smallButton ? 40 : 56,
          ),
        ),
        padding: _textStyle == AppTextStyle.smallButton
            ? MaterialStateProperty.all(EdgeInsets.zero)
            : MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 16),
              ),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
        textStyle: MaterialStateProperty.all(_textStyle),
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
