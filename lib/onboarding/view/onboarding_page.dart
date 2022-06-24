import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/onboarding/onboarding.dart';
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
        ),
        child: const OnboardingView(),
      ),
    );
  }
}
