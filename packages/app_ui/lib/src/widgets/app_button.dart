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
  })  : _buttonColor = buttonColor ?? Colors.white,
        _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.black,
        _elevation = elevation ?? 0,
        super(key: key);

  /// Filled black button.
  const AppButton.black({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.black,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
        );

  /// Filled blue dress button.
  const AppButton.blueDress({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.blueDress,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
        );

  /// Filled crystal blue button.
  const AppButton.crystalBlue({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.crystalBlue,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
        );

  /// Filled red wine button.
  const AppButton.redWine({
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
        );

  /// Filled dark aqua blue button.
  const AppButton.darkAqua({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
    required Widget child,
  }) : this._(
          key: key,
          onPressed: onPressed,
          buttonColor: AppColors.darkAqua,
          child: child,
          foregroundColor: AppColors.white,
          elevation: elevation,
        );

  /// Outlined transparent button.
  const AppButton.outlinedTransparent({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
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
        );

  /// Outlined white button.
  const AppButton.outlinedWhite({
    Key? key,
    VoidCallback? onPressed,
    double? elevation,
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

  /// [Widget] displayed on the button.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: MaterialStateProperty.all(
          const Size(double.infinity, 56),
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 40),
        ),
        backgroundColor: MaterialStateProperty.all(_buttonColor),
        elevation: MaterialStateProperty.all(_elevation),
        foregroundColor: MaterialStateProperty.all(_foregroundColor),
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
