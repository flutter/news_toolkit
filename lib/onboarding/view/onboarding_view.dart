import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

class OnboardinView extends StatelessWidget {
  const OnboardinView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final l10n = context.l10n;

    return SizedBox(
      height: MediaQuery.of(context).size.height * .59,
      child: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          OnboardingViewItem(
            numberPageTitle: l10n.onboardingItemFirstNumberTitle,
            title: l10n.onboardingItemFirstTitle,
            subtitle: l10n.onboardingItemFirstSubtitleTitle,
            primaryButtonTitle: l10n.onboardingItemFirstButtonTitle,
            primaryButtonOnPressed: () {},
            secondaryButtonOnPressed: () => controller.animateToPage(
              1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          OnboardingViewItem(
            numberPageTitle: l10n.onboardingItemSecondNumberTitle,
            title: l10n.onboardingItemSecondTitle,
            subtitle: l10n.onboardingItemSecondSubtitleTitle,
            primaryButtonTitle: l10n.onboardingItemSecondButtonTitle,
            primaryButtonOnPressed: () {},
            secondaryButtonOnPressed: () =>
                context.read<AppBloc>().add(AppOnboardingCompleted()),
          ),
        ],
      ),
    );
  }
}
