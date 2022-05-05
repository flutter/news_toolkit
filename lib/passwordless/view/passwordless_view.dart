import 'package:app_ui/app_ui.dart'
    show AppSpacing, ScrollableColumn, AppColors, AppButton;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';

class PasswordlessView extends StatelessWidget {
  const PasswordlessView({
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
        AppSpacing.xxlg,
      ),
      children: [
        const PasswordlessHeader(),
        const SizedBox(height: AppSpacing.xxxlg),
        Assets.images.passwordLessEmail.svg(),
        const SizedBox(height: AppSpacing.xxxlg),
        PasswordlessSubtitle(email: email),
        const Spacer(),
        const PasswordlessOpenEmailButton()
      ],
    );
  }
}

@visibleForTesting
class PasswordlessHeader extends StatelessWidget {
  const PasswordlessHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.passwordLessHeader,
      key: const Key('passwordLess_header'),
      style: Theme.of(context).textTheme.headline3,
    );
  }
}

@visibleForTesting
class PasswordlessSubtitle extends StatelessWidget {
  const PasswordlessSubtitle({
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

@visibleForTesting
class PasswordlessOpenEmailButton extends StatelessWidget {
  const PasswordlessOpenEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton.darkAqua(
      key: const Key('passwordLess_openMailButton'),
      onPressed: () {},
      child: Text(context.l10n.openMailAppButtonText),
    );
  }
}
