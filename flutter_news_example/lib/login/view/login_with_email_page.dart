import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

class LoginWithEmailPage extends StatelessWidget {
  const LoginWithEmailPage({super.key});

  static const routePath = 'login-with-email';

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const LoginWithEmailPage();

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
