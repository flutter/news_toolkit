import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';

class NavigationDrawerSubscribe extends StatelessWidget {
  const NavigationDrawerSubscribe({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        NavigationDrawerSubscribeTitle(),
        NavigationDrawerSubscribeSubtitle(),
        SizedBox(height: AppSpacing.xlg),
        NavigationDrawerSubscribeButton(),
      ],
    );
  }
}

@visibleForTesting
class NavigationDrawerSubscribeTitle extends StatelessWidget {
  const NavigationDrawerSubscribeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg + AppSpacing.xxs,
        ),
        child: Text(
          context.l10n.navigationDrawerSubscribeTitle,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: AppColors.highEmphasisPrimary,
              ),
        ),
      ),
    );
  }
}

@visibleForTesting
class NavigationDrawerSubscribeSubtitle extends StatelessWidget {
  const NavigationDrawerSubscribeSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Text(
        context.l10n.navigationDrawerSubscribeSubtitle,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: AppColors.mediumEmphasisPrimary,
            ),
      ),
    );
  }
}

@visibleForTesting
class NavigationDrawerSubscribeButton extends StatelessWidget {
  const NavigationDrawerSubscribeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton.redWine(
      onPressed: () => showPurchaseSubscriptionDialog(context: context),
      child: Text(context.l10n.subscribeButtonText),
    );
  }
}
