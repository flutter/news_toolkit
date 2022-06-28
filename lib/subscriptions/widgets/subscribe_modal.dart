import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/analytics/analytics.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';
import 'package:visibility_detector/visibility_detector.dart';

@visibleForTesting
class SubscribeModal extends StatefulWidget {
  const SubscribeModal({super.key});

  @override
  State<SubscribeModal> createState() => _SubscribeModalState();
}

class _SubscribeModalState extends State<SubscribeModal> {
  bool _modalShown = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isLoggedIn = context.select<AppBloc, bool>(
      (AppBloc bloc) => bloc.state.status == AppStatus.authenticated,
    );

    final articleTitle = context.select((ArticleBloc bloc) => bloc.state.title);

    return VisibilityDetector(
      key: const Key('subscribeModal'),
      onVisibilityChanged: _modalShown
          ? null
          : (visibility) {
              if (!visibility.visibleBounds.isEmpty) {
                context.read<AnalyticsBloc>().add(
                      TrackAnalyticsEvent(
                        PaywallPromptEvent.impression(
                          impression: PaywallPromptImpression.subscription,
                          articleTitle: articleTitle ?? '',
                        ),
                      ),
                    );
                setState(() => _modalShown = true);
              }
            },
      child: ColoredBox(
        color: AppColors.darkBackground,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
                child: Text(
                  l10n.subscribeModalTitle,
                  style:
                      theme.textTheme.headline3?.apply(color: AppColors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
                child: Text(
                  l10n.subscribeModalSubtitle,
                  style: theme.textTheme.subtitle1
                      ?.apply(color: AppColors.mediumEmphasisPrimary),
                ),
              ),
              const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg + AppSpacing.xxs,
                ),
                child: AppButton.redWine(
                  key: const Key('subscribeModal_subscribeButton'),
                  child: Text(l10n.subscribeButtonText),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (!isLoggedIn) ...[
                const SizedBox(height: AppSpacing.sm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg + AppSpacing.xxs,
                  ),
                  child: AppButton.outlinedTransparentWhite(
                    key: const Key('subscribeModal_logInButton'),
                    child: Text(l10n.subscribeModalLogInButton),
                    onPressed: () => showAppModal<void>(
                      context: context,
                      builder: (context) => const LoginModal(),
                      routeSettings: const RouteSettings(name: LoginModal.name),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
