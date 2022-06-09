import 'package:app_ui/app_ui.dart'
    show AppButton, AppSpacing, AppColors, showAppModal;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';

@visibleForTesting
class SubscribeLimitModal extends StatelessWidget {
  const SubscribeLimitModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final isLoggedIn = context
        .select((AppBloc bloc) => bloc.state.status == AppStatus.authenticated);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xlg),
      color: AppColors.darkBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.subscribeLimitModalTitle,
            style: theme.textTheme.headline3?.apply(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.sm + AppSpacing.xxs),
          Text(
            l10n.subscribeLimitModalSubtitle,
            style: theme.textTheme.subtitle1
                ?.apply(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          AppButton.redWine(
            key: const Key('subscribeLimitModal_subscribeButton'),
            child: Text(l10n.subscribeButtonText),
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!isLoggedIn)
            AppButton.outlinedTransparentWhite(
              key: const Key('subscribeLimitModal_logInButton'),
              child: Text(l10n.subscribeLimitModalLogInButton),
              onPressed: () => showAppModal<void>(
                context: context,
                builder: (context) => const LoginModal(),
                routeSettings: const RouteSettings(name: LoginModal.name),
              ),
            ),
          if (!isLoggedIn) const SizedBox(height: AppSpacing.lg),
          AppButton.transparentWhite(
            key: const Key('subscribeLimitModal_watchVideo'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.video.svg(),
                const SizedBox(width: AppSpacing.sm),
                Text(l10n.subscribeLimitModalWatchVideoButton),
              ],
            ),
            onPressed: () {},
          ),
          if (!isLoggedIn) const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
