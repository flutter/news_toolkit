import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class SubscribeBox extends StatelessWidget {
  const SubscribeBox({super.key, required this.onButtonPressed});

  final VoidCallback onButtonPressed;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.userProfileNotSubscriberSubtitle,
            style: theme.textTheme.subtitle1?.copyWith(
              fontWeight: AppFontWeight.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.userProfileNotSubscriberMessage,
            style: theme.textTheme.bodyText2
                ?.copyWith(color: AppColors.mediumEmphasisSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.smallRedWine(
              onPressed: onButtonPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.userProfileSubscribeNowButtonText),
                ],
              )),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
