import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/onboarding/onboarding.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();

  static const _onboardingItemSwitchDuration = Duration(milliseconds: 500);
  static const _onboardingPageTwo = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if ((state is EnablingAdTrackingSucceeded ||
                state is EnablingAdTrackingFailed) &&
            _controller.page != _onboardingPageTwo) {
          _controller.animateToPage(
            _onboardingPageTwo,
            duration: _onboardingItemSwitchDuration,
            curve: Curves.easeInOut,
          );
        } else if (state is EnablingNotificationsSucceeded) {
          context.read<AppBloc>().add(const AppOnboardingCompleted());
        }
      },
      child: ScrollableColumn(
        key: const Key('onboarding_scrollableColumn'),
        mainAxisSize: MainAxisSize.min,
        children: [
          const _OnboardingTitle(),
          const _OnboardingSubtitle(),
          SizedBox(
            height: MediaQuery.of(context).size.height * .59,
            child: PageView(
              key: const Key('onboarding_pageView'),
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OnboardingViewItem(
                  key: const Key('onboarding_pageOne'),
                  pageNumberTitle: l10n.onboardingItemFirstNumberTitle,
                  title: l10n.onboardingItemFirstTitle,
                  subtitle: l10n.onboardingItemFirstSubtitleTitle,
                  primaryButton: AppButton.darkAqua(
                    key: const Key('onboardingItem_primaryButton_pageOne'),
                    onPressed: () => context
                        .read<OnboardingBloc>()
                        .add(const EnableAdTrackingRequested()),
                    child: Text(l10n.onboardingItemFirstButtonTitle),
                  ),
                  secondaryButton: AppButton.smallTransparent(
                    key: const Key('onboardingItem_secondaryButton_pageOne'),
                    onPressed: () => _controller.animateToPage(
                      _onboardingPageTwo,
                      duration: _onboardingItemSwitchDuration,
                      curve: Curves.easeInOut,
                    ),
                    child:
                        Text(context.l10n.onboardingItemSecondaryButtonTitle),
                  ),
                ),
                OnboardingViewItem(
                  key: const Key('onboarding_pageTwo'),
                  pageNumberTitle: l10n.onboardingItemSecondNumberTitle,
                  title: l10n.onboardingItemSecondTitle,
                  subtitle: l10n.onboardingItemSecondSubtitleTitle,
                  primaryButton: AppButton.darkAqua(
                    key: const Key('onboardingItem_primaryButton_pageTwo'),
                    onPressed: () => context
                        .read<OnboardingBloc>()
                        .add(const EnableNotificationsRequested()),
                    child: Text(l10n.onboardingItemSecondButtonTitle),
                  ),
                  secondaryButton: AppButton.smallTransparent(
                    key: const Key('onboardingItem_secondaryButton_pageTwo'),
                    onPressed: () => context
                        .read<AppBloc>()
                        .add(const AppOnboardingCompleted()),
                    child:
                        Text(context.l10n.onboardingItemSecondaryButtonTitle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      key: const Key('onboardingView_onboardingTitle'),
      padding: const EdgeInsets.only(
        top: AppSpacing.xxxlg + AppSpacing.sm,
        bottom: AppSpacing.xxs,
      ),
      child: Text(
        context.l10n.onboardingWelcomeTitle,
        style: theme.textTheme.displayLarge?.apply(
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
      key: const Key('onboardingView_onboardingSubtitle'),
      padding: const EdgeInsets.only(
        top: AppSpacing.xlg,
      ),
      child: Text(
        context.l10n.onboardingSubtitle,
        style: theme.textTheme.titleMedium?.apply(
          color: AppColors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
