import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginPage());

  static const String name = '/loginPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(context.read<UserRepository>()),
      child: const LoginForm(),
    );
  }
}
