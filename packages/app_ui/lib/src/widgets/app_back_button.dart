import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_back_button}
/// IconButton displayed in the application.
/// Navigates back when is pressed.
/// {@endtemplate}

@visibleForTesting
class AppBackButton extends StatelessWidget {
  /// {@macro app_back_button}
  const AppBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Assets.icons.backIcon.svg(),
    );
  }
}
