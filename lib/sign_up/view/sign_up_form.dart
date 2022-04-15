import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/sign_up/sign_up.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.signUpFailure)),
            );
        }
      },
      child: const ScrollableColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailInput(),
          SizedBox(height: AppSpacing.xs),
          _PasswordInput(),
          SizedBox(height: AppSpacing.xs),
          _SignUpButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final email = context.select((SignUpBloc bloc) => bloc.state.email);
    return TextField(
      key: const Key('signUpForm_emailInput_textField'),
      onChanged: (email) {
        context.read<SignUpBloc>().add(SignUpEmailChanged(email));
      },
      decoration: InputDecoration(
        helperText: '',
        labelText: l10n.emailInputLabelText,
        errorText: email.invalid ? l10n.invalidEmailInputErrorText : null,
      ),
      autocorrect: false,
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final password = context.select((SignUpBloc bloc) => bloc.state.password);
    return TextField(
      key: const Key('signUpForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<SignUpBloc>().add(SignUpPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        helperText: '',
        labelText: l10n.passwordInputLabelText,
        errorText: password.invalid ? l10n.invalidPasswordInputErrorText : null,
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((SignUpBloc bloc) => bloc.state.status);
    return ElevatedButton(
      key: const Key('signUpForm_continue_elevatedButton'),
      onPressed: status.isValidated
          ? () => context.read<SignUpBloc>().add(SignUpSubmitted())
          : null,
      child: status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : Text(l10n.signUpButtonText),
    );
  }
}
