import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginWithEmailPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBackButton(),
          actions: [
            IconButton(
              key: const Key('loginWithEmailPage_closeIcon'),
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: const LoginWithEmailForm(),
      ),
    );
  }
}
