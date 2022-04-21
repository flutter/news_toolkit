import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.xxxlg,
          horizontal: AppSpacing.xlg,
        ),
        child: BlocProvider(
          create: (_) => LoginBloc(context.read<UserRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
