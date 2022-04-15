import 'package:flutter/widgets.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.onboardingRequired:
      return [OnboardingPage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
  }
}
