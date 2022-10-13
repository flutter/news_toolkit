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

  static Route route({
    required Function()? onPressed,
    required String errorText,
    required String refreshButtonText,
  }) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => NetworkErrorAlert(
        onPressed: onPressed,
        errorText: errorText,
        refreshButtonText: refreshButtonText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 100,
            color: AppColors.mediumEmphasisSurface,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            errorText,
            style: UITextStyle.bodyText1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            // TODO find a better way to handle padding
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
            child: AppButton.darkAqua(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: UITextStyle.button.fontSize,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    refreshButtonText,
                    style: UITextStyle.button,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
