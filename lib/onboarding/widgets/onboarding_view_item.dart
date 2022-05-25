import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class OnboardingViewItem extends StatelessWidget {
  const OnboardingViewItem({
    required this.numberPageTitle,
    required this.title,
    required this.subtitle,
    required this.primaryButtonTitle,
    required this.primaryButtonOnPressed,
    required this.secondaryButtonOnPressed,
  });

  final String numberPageTitle;
  final String title;
  final String subtitle;
  final String primaryButtonTitle;
  final VoidCallback primaryButtonOnPressed;
  final VoidCallback secondaryButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxlg,
        AppSpacing.lg,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            Text(
              key: const Key('onboardingItem_pageNumberTitle'),
              numberPageTitle,
              style: theme.textTheme.overline?.apply(
                color: AppColors.secondary.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
            Text(
              key: const Key('onboardingItem_title'),
              title,
              style: theme.textTheme.headline4?.apply(
                color: AppColors.highEmphasisSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              key: const Key('onboardingItem_subtitle'),
              subtitle,
              style: theme.textTheme.subtitle1?.apply(
                color: AppColors.mediumEmphasisSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            AppButton.darkAqua(
              key: const Key('onboardingItem_primaryButton'),
              onPressed: primaryButtonOnPressed,
              child: Text(primaryButtonTitle),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton.smallTransparent(
              key: const Key('onboardingItem_secondaryButton'),
              onPressed: secondaryButtonOnPressed,
              child: Text(context.l10n.onboardingItemSecondaryButtonTitle),
            )
          ],
        ),
      ),
    );
  }
}
