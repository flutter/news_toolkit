import 'package:app_ui/app_ui.dart'
    show AppSpacing, AppColors, AppButton, Assets;
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';

class MagicLinkPromptView extends StatelessWidget {
  const MagicLinkPromptView({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    return _ScrollableColumn(
      mainAxisSize: MainAxisSize.min,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xlg,
        AppSpacing.xlg,
        AppSpacing.xlg,
        AppSpacing.xxlg,
      ),
      children: [
        const MagicLinkPromptHeader(),
        const SizedBox(height: AppSpacing.xxxlg),
        Assets.icons.envelopeOpen.svg(),
        const SizedBox(height: AppSpacing.xxxlg),
        MagicLinkPromptSubtitle(email: email),
        const Spacer(),
        MagicLinkPromptOpenEmailButton()
      ],
    );
  }
}

@visibleForTesting
class MagicLinkPromptHeader extends StatelessWidget {
  const MagicLinkPromptHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.magicLinkPromptHeader,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}

@visibleForTesting
class MagicLinkPromptSubtitle extends StatelessWidget {
  const MagicLinkPromptSubtitle({
    super.key,
    required this.email,
  });

  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          context.l10n.magicLinkPromptTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.apply(
            color: AppColors.darkAqua,
          ),
        ),
        const SizedBox(height: AppSpacing.xxlg),
        Text(
          context.l10n.magicLinkPromptSubtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

@visibleForTesting
class MagicLinkPromptOpenEmailButton extends StatelessWidget {
  MagicLinkPromptOpenEmailButton({
    EmailLauncher? emailLauncher,
    super.key,
  }) : _emailLauncher = emailLauncher ?? EmailLauncher();

  final EmailLauncher _emailLauncher;

  @override
  Widget build(BuildContext context) {
    return AppButton.darkAqua(
      key: const Key('magicLinkPrompt_openMailButton_appButton'),
      onPressed: _emailLauncher.launchEmailApp,
      child: Text(context.l10n.openMailAppButtonText),
    );
  }
}

class _ScrollableColumn extends StatelessWidget {
  const _ScrollableColumn({
    required this.children,
    this.mainAxisSize = MainAxisSize.max,
    this.padding,
  });

  final List<Widget> children;

  final MainAxisSize mainAxisSize;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: Column(
                  mainAxisSize: mainAxisSize,
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
