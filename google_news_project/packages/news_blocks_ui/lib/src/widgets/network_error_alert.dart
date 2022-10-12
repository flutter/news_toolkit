import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_logo}
/// A network error alert.
/// {@endtemplate}
class NetworkErrorAlert extends StatelessWidget {
  /// {@macro network_error_alert}
  const NetworkErrorAlert({
    super.key,
    required this.onPressed,
    required this.errorText,
    required this.refreshButtonText,
  });

  /// An optional callback which is invoked when the widget button is pressed.
  /// No button will be displayed if onPress is null.
  final Function()? onPressed;

  /// Text displayed below the error icon describing the network issue.
  final String errorText;

  /// Text displayed within the refresh network button.
  final String refreshButtonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.error_outline,
          size: 80,
          color: AppColors.mediumEmphasisSurface,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(errorText),
        AppButton.darkAqua(
          onPressed: onPressed,
          child: Row(
            children: [
              const Icon(
                Icons.refresh,
              ),
              Text(refreshButtonText),
            ],
          ),
        ),
      ],
    );
  }
}
