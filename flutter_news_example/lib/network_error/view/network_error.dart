import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

/// {@template network_error}
/// A network error alert page.
/// {@endtemplate}
class NetworkErrorPage extends StatelessWidget {
  /// {@macro network_error}
  const NetworkErrorPage({
    super.key,
  });

  static const routePath = 'network-error';

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const NetworkErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(leading: const AppBackButton()),
      body: const Center(
        child: NetworkError(),
      ),
    );
  }
}

/// {@template network_error}
/// A network error alert.
/// {@endtemplate}
class NetworkError extends StatelessWidget {
  /// {@macro network_error}
  const NetworkError({super.key, this.onRetry});

  /// An optional callback which is invoked when the retry button is pressed.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xlg),
        const Icon(
          Icons.error_outline,
          size: 80,
          color: AppColors.mediumHighEmphasisSurface,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.networkError,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
          child: AppButton.darkAqua(
            onPressed: onRetry ?? context.pop,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 0,
                  child: Icon(Icons.refresh, size: UITextStyle.button.fontSize),
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    l10n.networkErrorButton,
                    style: UITextStyle.button,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xlg),
      ],
    );
  }
}
