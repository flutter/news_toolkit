import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class SubscribePayWallModal extends StatelessWidget {
  const SubscribePayWallModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        _SubscribePayWallHeader(),
        _SubscribePayWallSubtitle(),
        _SubscribePayWallSubscribeButton(),
        _SubscribePayWallWatchVideo(),
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
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: GestureDetector(
            key: const Key('subscribePayWallModal_closeModal'),
            child: const Icon(Icons.close),
            onTap: () => Navigator.pop(context),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: AppSpacing.sm, top: AppSpacing.lg),
          child: Text(
            key: const Key('susbcribePayWallModal_title'),
            context.l10n.subscribePayWallTitle,
            style: theme.textTheme.headline5?.apply(
              color: AppColors.highEmphasisSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscribePayWallSubtitle extends StatelessWidget {
  const _SubscribePayWallSubtitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xlg + AppSpacing.xlg,
        top: AppSpacing.sm,
      ),
      child: Text(
        key: const Key('susbcribePayWallModal_subtitle'),
        context.l10n.subscribePayWallSubtitle,
        style: theme.textTheme.subtitle1?.apply(
          color: AppColors.mediumEmphasisSurface,
        ),
      ),
    );
  }
}

class _SubscribePayWallSubscribeButton extends StatelessWidget {
  const _SubscribePayWallSubscribeButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg + AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: AppButton.redWine(
        key: const Key('susbcribePayWallModal_subscribeButton'),
        child: Text(context.l10n.subscribeButtonText),
        onPressed: () {},
      ),
    );
  }
}

class _SubscribePayWallWatchVideo extends StatelessWidget {
  const _SubscribePayWallWatchVideo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: AppButton.transparentDarkAqua(
        key: const Key('susbcribePayWallModal_watchVideo'),
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
      ),
    );
  }
}
