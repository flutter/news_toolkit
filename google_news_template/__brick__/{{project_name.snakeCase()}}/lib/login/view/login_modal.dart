import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginModal extends StatelessWidget {
  const LoginModal({super.key});

  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => const LoginModal());

  static const String name = '/loginModal';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: const LoginForm(),
    );
  }
}
