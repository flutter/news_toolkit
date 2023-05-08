import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_back_button}
/// IconButton displayed in the application.
/// Navigates back when is pressed.
/// {@endtemplate}

class AppBackButton extends StatelessWidget {
  /// Creates a default instance of [AppBackButton].
  const AppBackButton({
    Key? key,
    VoidCallback? onPressed,
  }) : this._(
          key: key,
          isLight: false,
          onPressed: onPressed,
        );

  /// Creates a light instance of [AppBackButton].
  const AppBackButton.light({
    Key? key,
    VoidCallback? onPressed,
  }) : this._(
          key: key,
          isLight: true,
          onPressed: onPressed,
        );

  /// {@macro app_back_button}
  const AppBackButton._({required this.isLight, this.onPressed, super.key});

  /// Whether this app button is light.
  final bool isLight;

  /// Called when the back button has been tapped.
  /// Defaults to `Navigator.of(context).pop()`
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Assets.icons.backIcon.svg(
        colorFilter: ColorFilter.mode(
          isLight ? AppColors.white : AppColors.highEmphasisSurface,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
