import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/login//login.dart';
import 'package:user_repository/user_repository.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginWithEmailPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(context.read<UserRepository>()),
      child: const LoginWithEmailForm(),
    );
  }
}
