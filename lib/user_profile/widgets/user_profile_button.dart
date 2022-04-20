import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';

/// A user profile button which displays a [LoginButton]
/// for the unauthenticated user or an [OpenProfileButton]
/// for the authenticated user.
class UserProfileButton extends StatelessWidget {
  const UserProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAnonymous = context.select<AppBloc, bool>(
      (bloc) => bloc.state.user.isAnonymous,
    );

    return isAnonymous ? const LoginButton() : const OpenProfileButton();
  }
}

@visibleForTesting
class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Assets.icons.logInIcon.svg(),
      iconSize: 24,
      onPressed: () => Navigator.of(context).push<void>(LoginPage.route()),
      tooltip: context.l10n.loginTooltip,
    );
  }
}

@visibleForTesting
class OpenProfileButton extends StatelessWidget {
  const OpenProfileButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Assets.icons.profileIcon.svg(),
      iconSize: 24,
      onPressed: () {
        // TODO(bselwe): Open profile page.
      },
      tooltip: context.l10n.openProfileTooltip,
    );
  }
}
