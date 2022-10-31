import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';

class UserProfileSubscribeBox extends StatelessWidget {
  const UserProfileSubscribeBox({
    super.key,
    required this.onSubscribePressed,
  });

  final VoidCallback onSubscribePressed;

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
            l10n.userProfileSubscribeBoxSubtitle,
            style: theme.textTheme.subtitle1?.copyWith(
              fontWeight: AppFontWeight.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.userProfileSubscribeBoxMessage,
            style: theme.textTheme.bodyText2
                ?.copyWith(color: AppColors.mediumEmphasisSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton.smallRedWine(
            key: const Key('userProfileSubscribeBox_appButton'),
            onPressed: onSubscribePressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.userProfileSubscribeNowButtonText),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
