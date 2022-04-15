import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/reset_password/reset_password.dart';
import 'package:google_news_template/sign_up/sign_up.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.authenticationFailure)),
            );
        }
      },
      child: const ScrollableColumn(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LoginContent(),
          _LoginActions(),
        ],
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.appName, style: theme.textTheme.headline6),
        const SizedBox(height: AppSpacing.xlg),
        Text(l10n.loginWelcomeText, style: theme.textTheme.headline1),
        const SizedBox(height: AppSpacing.xxlg),
        _EmailInput(),
        const SizedBox(height: AppSpacing.xs),
        _PasswordInput(),
        const SizedBox(height: AppSpacing.xs),
        _ResetPasswordButton(),
      ],
    );
  }
}

class _LoginActions extends StatelessWidget {
  const _LoginActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LoginButton(),
        const SizedBox(height: AppSpacing.xlg),
        _GoogleLoginButton(),
        if (theme.platform == TargetPlatform.iOS) ...[
          const SizedBox(height: AppSpacing.xlg),
          _AppleLoginButton(),
        ],
        const SizedBox(height: AppSpacing.xxlg),
        _SignUpButton(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.select((LoginBloc bloc) => bloc.state.email);
    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email));
      },
      decoration: InputDecoration(
        helperText: '',
        labelText: l10n.emailInputLabelText,
        errorText: email.invalid ? l10n.invalidEmailInputErrorText : null,
      ),
      autofillHints: const [AutofillHints.email],
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Theme.of(context).brightness,
      autocorrect: false,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final password = context.select((LoginBloc bloc) => bloc.state.password);
    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
      obscureText: true,
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      keyboardAppearance: Theme.of(context).brightness,
      decoration: InputDecoration(
        helperText: '',
        labelText: l10n.passwordInputLabelText,
        errorText: password.invalid ? l10n.invalidPasswordInputErrorText : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('loginForm_continue_elevatedButton'),
          onPressed: state.email.valid && state.password.valid
              ? () => context.read<LoginBloc>().add(LoginCredentialsSubmitted())
              : null,
          child: state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : Text(l10n.loginButtonText),
        );
      },
    );
  }
}

class _AppleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton.icon(
      key: const Key('loginForm_appleLogin_elevatedButton'),
      label: Text(l10n.signInWithAppleButtonText),
      icon: const Icon(FontAwesomeIcons.apple, color: AppColors.white),
      onPressed: () => context.read<LoginBloc>().add(LoginAppleSubmitted()),
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ElevatedButton(
      key: const Key('loginForm_googleLogin_elevatedButton'),
      onPressed: () => context.read<LoginBloc>().add(LoginGoogleSubmitted()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.google, color: AppColors.white),
          const SizedBox(width: AppSpacing.xlg),
          Text(l10n.signInWithGoogleButtonText),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      key: const Key('loginForm_createAccount_textButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(l10n.createAccountButtonText),
    );
  }
}

class _ResetPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TextButton(
      key: const Key('loginForm_forgotPassword_textButton'),
      onPressed: () => Navigator.of(context).push<void>(
        ResetPasswordPage.route(),
      ),
      child: Text(l10n.forgotPasswordText),
    );
  }
}
