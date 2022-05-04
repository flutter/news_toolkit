import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class NavigationDrawerSubscribe extends StatelessWidget {
  const NavigationDrawerSubscribe({Key? key}) : super(key: key);

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
  const NavigationDrawerSubscribeTitle({Key? key}) : super(key: key);

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
  const NavigationDrawerSubscribeSubtitle({Key? key}) : super(key: key);

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
  const NavigationDrawerSubscribeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton.redWine(
      onPressed: () {},
      child: Text(context.l10n.navigationDrawerSubscribeButtonText),
    );
  }
}
