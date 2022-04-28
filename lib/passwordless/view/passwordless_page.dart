import 'package:flutter/material.dart';
import 'package:google_news_template/passwordless/view/passwordless_view.dart';

class PasswordLessPage extends StatelessWidget {
  const PasswordLessPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  Route route() => MaterialPageRoute<void>(
        builder: (_) => PasswordLessPage(
          email: email,
        ),
      );
  @override
  Widget build(BuildContext context) {
    var count = 0;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: const Key('signUpPage_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () =>
                Navigator.of(context).popUntil((_) => count++ >= 2),
          )
        ],
      ),
      body: PasswordLessView(
        email: email,
      ),
    );
  }
}
