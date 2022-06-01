import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

@visibleForTesting
class SubscribeLoggedInModal extends StatelessWidget {
  const SubscribeLoggedInModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: const [
        _SubscribeLoggedInHeader(),
        _SubscribeLoggedInSubtitle(),
        _SubscribeLoggedInButton()
      ],
    );
  }
}

class _SubscribeLoggedInHeader extends StatelessWidget {
  const _SubscribeLoggedInHeader();

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
            key: const Key('subscribeLoggedInModal_closeModal'),
            child: const Icon(Icons.close),
            onTap: () => Navigator.pop(context),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: AppSpacing.sm, top: AppSpacing.lg),
          child: Text(
            key: const Key('susbcribeLoggedInModal_title'),
            context.l10n.subscribeLoggedInTitle,
            style: theme.textTheme.headline5?.apply(
              color: AppColors.highEmphasisSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscribeLoggedInSubtitle extends StatelessWidget {
  const _SubscribeLoggedInSubtitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xlg + AppSpacing.xlg,
        top: AppSpacing.sm,
      ),
      child: Text(
        key: const Key('susbcribeLoggedInModal_subtitle'),
        context.l10n.subscribeLoggedInSubtitle,
        style: theme.textTheme.subtitle1?.apply(
          color: AppColors.mediumEmphasisSurface,
        ),
      ),
    );
  }
}

class _SubscribeLoggedInButton extends StatelessWidget {
  const _SubscribeLoggedInButton();

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
        key: const Key('susbcribeLoggedInModal_subscribeButton'),
        child: Text(context.l10n.subscribeButtonText),
        onPressed: () {},
      ),
    );
  }
}
