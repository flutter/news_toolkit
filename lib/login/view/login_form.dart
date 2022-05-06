import 'package:app_ui/app_ui.dart' show AppButton, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.pop(context);
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.authenticationFailure)),
              );
          }
        },
        child: const _LoginContent(),
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxlg,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        const _LoginTitleAndCloseButton(),
        const SizedBox(height: AppSpacing.md),
        const _LoginSubtitle(),
        const SizedBox(height: AppSpacing.lg),
        _GoogleLoginButton(),
        if (theme.platform == TargetPlatform.iOS) ...[
          const SizedBox(height: AppSpacing.lg),
          _AppleLoginButton(),
        ],
        const SizedBox(height: AppSpacing.lg),
        _FacebookLoginButton(),
        const SizedBox(height: AppSpacing.lg),
        _TwitterLoginButton(),
        const SizedBox(height: AppSpacing.lg),
        _ContinueWithEmailLoginButton()
      ],
    );
  }
}

class _LoginTitleAndCloseButton extends StatelessWidget {
  const _LoginTitleAndCloseButton({Key? key}) : super(key: key);

  static const _contentSpace = 2.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          key: const Key('loginForm_closeModal'),
          child: const Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(
          width: AppSpacing.md + _contentSpace,
        ),
        Text(
          context.l10n.loginModalTitle,
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
  }
}

class _LoginSubtitle extends StatelessWidget {
  const _LoginSubtitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xxlg),
      child: Text(
        context.l10n.loginModalSubtitle,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}

class _AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.black(
      key: const Key('loginForm_appleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginAppleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.apple.svg(),
          const SizedBox(width: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Assets.images.continueWithApple.svg(),
          ),
        ],
      ),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.outlinedWhite(
      key: const Key('loginForm_googleLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginGoogleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.google.svg(),
          const SizedBox(width: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xxs),
            child: Assets.images.continueWithGoogle.svg(),
          ),
        ],
      ),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.blueDress(
      key: const Key('loginForm_facebookLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginFacebookSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.facebook.svg(),
          const SizedBox(width: AppSpacing.lg),
          Assets.images.continueWithFacebook.svg(),
        ],
      ),
    );
  }
}

class _TwitterLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.crystalBlue(
      key: const Key('loginForm_twitterLogin_appButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginTwitterSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.twitter.svg(),
          const SizedBox(width: AppSpacing.lg),
          Assets.images.continueWithTwitter.svg(),
        ],
      ),
    );
  }
}

class _ContinueWithEmailLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton.outlinedTransparent(
      key: const Key('loginForm_emailLogin_appButton'),
      onPressed: () => Navigator.of(context).push<void>(
        LoginWithEmailPage.route(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.emailOutline.svg(),
          const SizedBox(width: AppSpacing.lg),
          Text(context.l10n.loginWithEmailButtonText),
        ],
      ),
    );
  }
}
