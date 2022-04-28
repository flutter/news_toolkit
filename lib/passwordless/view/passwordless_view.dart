import 'package:app_ui/app_ui.dart'
    show AppSpacing, ScrollableColumn, AppColors, AppButton;
import 'package:flutter/material.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';

class PasswordLessView extends StatelessWidget {
  const PasswordLessView({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return ScrollableColumn(
      mainAxisSize: MainAxisSize.min,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xlg,
        AppSpacing.xlg,
        AppSpacing.xlg,
        AppSpacing.xxxlg,
      ),
      children: [
        const _HeaderPasswordLess(),
        const SizedBox(height: AppSpacing.xxxlg),
        Assets.images.passwordLessEmail.svg(),
        const SizedBox(height: AppSpacing.xxxlg),
        _SubtitlePasswordLess(email: email),
        const Spacer(),
        const _OpenEmailAppButton()
      ],
    );
  }
}

class _HeaderPasswordLess extends StatelessWidget {
  const _HeaderPasswordLess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.passwordLessHeader,
      key: const Key('passwordLess_header'),
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

class _SubtitlePasswordLess extends StatelessWidget {
  const _SubtitlePasswordLess({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('passwordLess_subtitle'),
      children: [
        Text(
          context.l10n.passwordLessTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1?.apply(
                color: AppColors.darkAqua,
              ),
        ),
        const SizedBox(height: AppSpacing.xxlg),
        Text(
          context.l10n.passwordLessSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _OpenEmailAppButton extends StatelessWidget {
  const _OpenEmailAppButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton.darkAqua(
      key: const Key('passwordLess_openMailButton'),
      onPressed: () {},
      child: Text(context.l10n.openMailAppButtonText),
    );
  }
}
