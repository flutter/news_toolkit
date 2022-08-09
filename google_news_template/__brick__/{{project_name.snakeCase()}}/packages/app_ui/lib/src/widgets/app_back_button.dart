import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_back_button}
/// IconButton displayed in the application.
/// Navigates back when is pressed.
/// {@endtemplate}

class AppBackButton extends StatelessWidget {
  /// Creates a default instance of [AppBackButton].
  const AppBackButton({Key? key}) : this._(key: key, isLight: false);

  /// Creates a light instance of [AppBackButton].
  const AppBackButton.light({Key? key}) : this._(key: key, isLight: true);

  /// {@macro app_back_button}
  const AppBackButton._({super.key, required this.isLight});

  /// Whether this app button is light.
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Assets.icons.backIcon.svg(
        color: isLight ? AppColors.white : AppColors.highEmphasisSurface,
      ),
    );
  }
}
