import 'package:flutter/widgets.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

List<Page> onGenerateOnboardingPages(OnboardingState state, List<Page> pages) {
  switch (state) {
    case OnboardingState.initial:
      return [OnboardingWelcome.page()];
  }
}
