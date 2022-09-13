
{{#include_ads}}
import 'package:ads_consent_client/ads_consent_client.dart';
{{/include_ads}}
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/onboarding/onboarding.dart';
import 'package:notifications_repository/notifications_repository.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Page page() => const MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: BlocProvider(
        create: (_) => OnboardingBloc(
          notificationsRepository: context.read<NotificationsRepository>(),
{{#include_ads}}
          adsConsentClient: context.read<AdsConsentClient>(),
{{/include_ads}}
        ),
        child: const OnboardingView(),
      ),
    );
  }
}
