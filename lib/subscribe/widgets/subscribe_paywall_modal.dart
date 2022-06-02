import 'package:app_ui/app_ui.dart' show AppColors, AppSpacing, AppButton;
import 'package:flutter/material.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';

class SubscribePayWallModal extends StatelessWidget {
  const SubscribePayWallModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _SubscribePayWallHeader(),
        SizedBox(height: AppSpacing.lg),
        _SubscribePayWallSubscribeButton(),
        SizedBox(height: AppSpacing.lg),
        _SubscribePayWallWatchVideo(),
        SizedBox(height: AppSpacing.xlg),
      ],
    );
  }
}

class _SubscribePayWallHeader extends StatelessWidget {
  const _SubscribePayWallHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: const Key('subscribePayWallModal_closeModal'),
          child: const Padding(
            padding: EdgeInsets.only(top: AppSpacing.xxs),
            child: Icon(Icons.close),
          ),
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: const Key('subscribePayWallModal_title'),
              context.l10n.subscribePayWallTitle,
              style: theme.textTheme.headline5?.apply(
                color: AppColors.highEmphasisSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              key: const Key('subscribePayWallModal_subtitle'),
              context.l10n.subscribePayWallSubtitle,
              style: theme.textTheme.subtitle1?.apply(
                color: AppColors.mediumEmphasisSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SubscribePayWallSubscribeButton extends StatelessWidget {
  const _SubscribePayWallSubscribeButton();

  @override
  Widget build(BuildContext context) {
    return AppButton.redWine(
      key: const Key('subscribePayWallModal_subscribeButton'),
      child: Text(context.l10n.subscribeButtonText),
      onPressed: () {},
    );
  }
}

class _SubscribePayWallWatchVideo extends StatelessWidget {
  const _SubscribePayWallWatchVideo();

  @override
  Widget build(BuildContext context) {
    return AppButton.transparent(
      key: const Key('subscribePayWallModal_watchVideo'),
      foregroundColor: AppColors.darkAqua,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.videoIcon.svg(),
          const SizedBox(width: AppSpacing.sm),
          Text(
            context.l10n.subscribePayWallWatchVideo,
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
