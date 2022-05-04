import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/login/login.dart';

class LoginWithEmailForm extends StatelessWidget {
  const LoginWithEmailForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(context.l10n.loginWithEmailFailure)),
              );
          }
        },
        child: const ScrollableColumn(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xlg,
            AppSpacing.lg,
            AppSpacing.xlg,
            AppSpacing.xxlg,
          ),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderTitle(),
            SizedBox(height: AppSpacing.xxxlg),
            _EmailInput(),
            _TermsAndPolicyLinkTexts(),
            Spacer(),
            _NextButton(),
          ],
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      context.l10n.loginWithEmailHeaderText,
      key: const Key('loginWithEmailForm_header_title'),
      style: theme.textTheme.headline3,
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final suffixVisible =
        context.select((LoginBloc bloc) => bloc.state.email.value.isNotEmpty);

    return AppEmailTextField(
      key: const Key('loginWithEmailForm_emailInput_textField'),
      controller: _controller,
      hintText: context.l10n.loginWithEmailTextFieldHint,
      onChanged: (email) =>
          context.read<LoginBloc>().add(LoginEmailChanged(email)),
      onSuffixPressed: () {
        _controller.clear();
        context.read<LoginBloc>().add(const LoginEmailChanged(''));
      },
      suffixVisible: suffixVisible,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _TermsAndPolicyLinkTexts extends StatelessWidget {
  const _TermsAndPolicyLinkTexts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        key: const Key('loginWithEmailForm_terms_and_privacy_policy'),
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: context.l10n.loginWithEmailSubtitleText,
              style: theme.textTheme.bodyText1,
            ),
            TextSpan(
              text: context.l10n.loginWithEmailTermsAndPrivacyPolicyText,
              style: theme.textTheme.bodyText1?.apply(
                color: AppColors.darkAqua,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          context.l10n.loginWithEmailTermsAndPolicyInfo,
                          style: theme.textTheme.button
                              ?.apply(color: AppColors.white),
                        ),
                      ),
                    );
                },
            ),
            TextSpan(
              text: '.',
              style: theme.textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((LoginBloc bloc) => bloc.state.status);
    return AppButton.darkAqua(
      key: const Key('loginWithEmailForm_nextButton'),
      onPressed: status.isValidated
          ? () => context.read<LoginBloc>().add(SendEmailLinkSubmitted())
          : null,
      child: status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : Text(l10n.nextButtonText),
    );
  }
}
