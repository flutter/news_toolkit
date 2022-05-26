import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final l10n = context.l10n;

    return ScrollableColumn(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _OnboardingTitle(),
        const _OnboardingSubtitle(),
        SizedBox(
          height: MediaQuery.of(context).size.height * .59,
          child: PageView(
            controller: controller,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              OnboardingViewItem(
                key: const Key('onboarding_pageOne'),
                numberPageTitle: l10n.onboardingItemFirstNumberTitle,
                title: l10n.onboardingItemFirstTitle,
                subtitle: l10n.onboardingItemFirstSubtitleTitle,
                primaryButton: AppButton.darkAqua(
                  key: const Key('onboardingItem_primaryButton_pageOne'),
                  onPressed: () {},
                  child: Text(l10n.onboardingItemFirstButtonTitle),
                ),
                secondaryButton: AppButton.smallTransparent(
                  key: const Key('onboardingItem_secondaryButton_pageOne'),
                  onPressed: () => controller.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                  child: Text(context.l10n.onboardingItemSecondaryButtonTitle),
                ),
              ),
              OnboardingViewItem(
                key: const Key('onboarding_pageTwo'),
                numberPageTitle: l10n.onboardingItemSecondNumberTitle,
                title: l10n.onboardingItemSecondTitle,
                subtitle: l10n.onboardingItemSecondSubtitleTitle,
                primaryButton: AppButton.darkAqua(
                  key: const Key('onboardingItem_primaryButton_pageTwo'),
                  onPressed: () {},
                  child: Text(l10n.onboardingItemSecondButtonTitle),
                ),
                secondaryButton: AppButton.smallTransparent(
                  key: const Key('onboardingItem_secondaryButton_pageTwo'),
                  onPressed: () =>
                      context.read<AppBloc>().add(AppOnboardingCompleted()),
                  child: Text(context.l10n.onboardingItemSecondaryButtonTitle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle();

  @override
  Widget build(BuildContext context) {
    const contentPadding = AppSpacing.sm;
    final theme = Theme.of(context);

    return Padding(
      key: const Key('onboardingView_onboardingTitle'),
      padding: const EdgeInsets.only(
        top: AppSpacing.xxxlg + contentPadding,
        bottom: AppSpacing.xxs,
      ),
      child: Text(
        context.l10n.onboardingWelcomeTitle,
        style: theme.textTheme.headline1?.apply(
          color: AppColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OnboardingSubtitle extends StatelessWidget {
  const _OnboardingSubtitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: const Key('onboardingView_onboardingsubTitle'),
      padding: const EdgeInsets.only(
        top: AppSpacing.xlg,
      ),
      child: Text(
        context.l10n.onboardingSubtitle,
        style: theme.textTheme.subtitle1?.apply(
          color: AppColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
