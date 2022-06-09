import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

@visibleForTesting
class SubscribeLoggedInOutModal extends StatelessWidget {
  const SubscribeLoggedInOutModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      color: AppColors.darkBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.subscribeModalLoggedInTitle,
            style: theme.textTheme.headline3?.apply(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
          Text(
            l10n.subscribeModalLoggedInSubtitle,
            style: theme.textTheme.subtitle1
                ?.apply(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          AppButton.redWine(
            key: const Key('subscribeLoggedIn_subscribeButton'),
            child: Text(l10n.subscribeButtonText),
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}
