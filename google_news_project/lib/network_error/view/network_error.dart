import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template network_error}
/// A network error alert.
/// {@endtemplate}
class NetworkError extends StatelessWidget {
  /// {@macro network_error}
  const NetworkError({
    super.key,
    this.onPressed,
    required this.errorText,
    required this.refreshButtonText,
  });

  /// An optional callback which is invoked when the widget button is pressed.
  final Function()? onPressed;

  /// Text displayed below the error icon describing the network issue.
  final String errorText;

  /// Text displayed within the refresh network button.
  final String refreshButtonText;

  /// Route constructor to display the widget inside a [Scaffold].
  static Route route({
    Function()? onPressed,
    required String errorText,
    required String refreshButtonText,
  }) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: const AppBackButton(),
        ),
        body: Center(
          child: NetworkError(
            onPressed: onPressed,
            errorText: errorText,
            refreshButtonText: refreshButtonText,
          ),
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
          const SizedBox(height: AppSpacing.xlg),
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
            constraints: const BoxConstraints(maxHeight: 75, maxWidth: 150),
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
                  Flexible(
                    child: Text(
                      refreshButtonText,
                      style: UITextStyle.button,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
