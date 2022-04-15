import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/reset_password/reset_password.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ResetPasswordBloc, ResetPasswordState>(
      listener: (context, state) {
        if (state.status.isSubmissionSuccess ||
            state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.resetPasswordSubmitText)),
            );
          Navigator.of(context).pop();
        }
      },
      child: const ScrollableColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailInput(),
          SizedBox(height: AppSpacing.xs),
          _SubmitButton(),
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
    final email = context.select((ResetPasswordBloc bloc) => bloc.state.email);
    return TextField(
      key: const Key('resetPasswordForm_emailInput_textField'),
      onChanged: (email) {
        context.read<ResetPasswordBloc>().add(ResetPasswordEmailChanged(email));
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status =
        context.select((ResetPasswordBloc bloc) => bloc.state.status);
    return ElevatedButton(
      key: const Key('submitResetPassword_continue_elevatedButton'),
      onPressed: status.isValidated
          ? () => context
              .read<ResetPasswordBloc>()
              .add(const ResetPasswordSubmitted())
          : null,
      child: status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : Text(l10n.submitButtonText),
    );
  }
}
