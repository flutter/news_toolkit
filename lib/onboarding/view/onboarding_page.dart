import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/onboarding/onboarding.dart';

enum OnboardingState { initial }

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Page page() => const MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return const FlowBuilder<OnboardingState>(
      state: OnboardingState.initial,
      onGeneratePages: onGenerateOnboardingPages,
    );
  }
}

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  static Page page() => const MaterialPage<void>(child: OnboardingWelcome());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: ScrollableColumn(
        children: [
          const Spacer(),
          Text(
            l10n.onboardingWelcomeTitle,
            style: theme.textTheme.headline2,
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _PageIndicator(state: OnboardingState.initial),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.xxlg,
                  ),
                ),
                onPressed: () =>
                    context.read<AppBloc>().add(AppOnboardingCompleted()),
                child: Text(l10n.onboardingNextButtonText),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.state});

  final OnboardingState state;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final value in OnboardingState.values) ...[
          _PageIndicatorDot(filled: value != state),
          const SizedBox(width: AppSpacing.md),
        ]
      ],
    );
  }
}

class _PageIndicatorDot extends StatelessWidget {
  const _PageIndicatorDot({this.filled = false});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.black,
      ),
      child: filled
          ? null
          : Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.white,
                ),
                child: const Material(
                  color: Colors.transparent,
                  type: MaterialType.circle,
                ),
              ),
            ),
    );
  }
}
