import 'package:app_ui/app_ui.dart' show AppSpacing, showAppModal;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

/// A user profile button which displays a [LoginButton]
/// for the unauthenticated user or an [OpenProfileButton]
/// for the authenticated user.
class UserProfileButton extends StatelessWidget {
  const UserProfileButton({super.key});

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
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Assets.icons.logInIcon.svg(),
      iconSize: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      onPressed: () => showAppModal<void>(
        context: context,
        builder: (context) => const LoginPage(),
        routeSettings: const RouteSettings(name: LoginPage.name),
      ),
      tooltip: context.l10n.loginTooltip,
    );
  }
}

@visibleForTesting
class OpenProfileButton extends StatelessWidget {
  const OpenProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Assets.icons.profileIcon.svg(),
      iconSize: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      onPressed: () => Navigator.of(context).push(UserProfilePage.route()),
      tooltip: context.l10n.openProfileTooltip,
    );
  }
}
