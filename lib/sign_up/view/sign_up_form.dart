import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
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
          _HeaderTitle(),
          SizedBox(height: AppSpacing.xxxlg),
          _EmailInput(),
          _TermsAndPolicyLinkTexts(),
          Spacer(),
          _NextButton(),
        ],
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.signUpHeaderText,
      key: const Key('signUpForm_header_title'),
      style: AppTextStyle.headline3,
    );
  }
}

class _EmailInput extends StatefulWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  State<_EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<_EmailInput> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final showDeleteIcon =
        context.select((SignUpBloc bloc) => bloc.state.showDeleteIcon);

    return AppEmailField(
      key: const Key('signUpForm_emailInput_textField'),
      controller: controller,
      hintText: context.l10n.signUpTextFieldHint,
      onChanged: (email) {
        context.read<SignUpBloc>().add(SignUpEmailChanged(email));
        if (email.isEmpty) {
          context.read<SignUpBloc>().add(SignUpHideDeleteIcon());
        }
      },
      onSuffixPressed: () {
        controller.text = '';
        context.read<SignUpBloc>().add(SignUpHideDeleteIcon());
      },
      suffixOpacity: showDeleteIcon ? 1 : 0,
    );
  }
}

class _TermsAndPolicyLinkTexts extends StatelessWidget {
  const _TermsAndPolicyLinkTexts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: RichText(
        key: const Key('signUpForm_terms_and_private_policy'),
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: context.l10n.signUpSubtitleText,
              style: AppTextStyle.bodyText1,
            ),
            TextSpan(
              text: context.l10n.signUpTermsAndPrivatePolicyText,
              style: AppTextStyle.bodyText1.apply(
                color: AppColors.darkAqua,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          context.l10n.signUpTermsAndPolicyInfo,
                          style: AppTextStyle.button,
                        ),
                      ),
                    );
                },
            ),
            TextSpan(
              text: '.',
              style: AppTextStyle.bodyText1,
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
    final status = context.select((SignUpBloc bloc) => bloc.state.status);
    return AppButton.darkAqua(
      key: const Key('signUpForm_next_elevatedButton'),
      onPressed: status.isValidated
          ? () => context.read<SignUpBloc>().add(SignUpSubmitted())
          : null,
      child: status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : Text(l10n.nextButtonText),
    );
  }
}
