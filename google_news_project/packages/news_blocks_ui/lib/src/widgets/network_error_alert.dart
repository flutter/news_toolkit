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
      pageBuilder: (_, __, ___) => Scaffold(
        backgroundColor: AppColors.background,
        body: NetworkErrorAlert(
          onPressed: onPressed,
          errorText: errorText,
          refreshButtonText: refreshButtonText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxxlg),
          const Icon(
            Icons.error_outline,
            size: 100,
            color: AppColors.mediumEmphasisSurface,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            errorText,
            style: UITextStyle.bodyText1.copyWith(
              color: AppColors.mediumEmphasisSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 75, maxWidth: 150),
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
          const SizedBox(height: AppSpacing.xxxlg),
        ],
      ),
    );
  }
}
