import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Page page() => const MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: ScrollableColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OnboardingTitle(),
            _OnboardingSubtitle(),
            OnboardinView()
          ],
        ),
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle({super.key});

  @override
  Widget build(BuildContext context) {
    const contentPadding = AppSpacing.sm;
    final theme = Theme.of(context);

    return Padding(
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
  const _OnboardingSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
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
