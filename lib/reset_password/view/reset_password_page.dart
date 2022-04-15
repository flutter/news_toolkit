import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/reset_password/reset_password.dart';
import 'package:user_repository/user_repository.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ResetPasswordPage());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.resetPasswordTitle,
          style: theme.textTheme.headline2,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxxlg,
          horizontal: AppSpacing.xlg,
        ),
        child: BlocProvider<ResetPasswordBloc>(
          create: (_) => ResetPasswordBloc(context.read<UserRepository>()),
          child: const ResetPasswordForm(),
        ),
      ),
    );
  }
}
