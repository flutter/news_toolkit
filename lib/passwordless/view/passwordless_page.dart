import 'package:flutter/material.dart';
import 'package:google_news_template/passwordless/view/passwordless_view.dart';

class PasswordlessPage extends StatelessWidget {
  const PasswordlessPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  static Route route({
    required String email,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => PasswordlessPage(
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
            key: const Key('passwordless_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () =>
                Navigator.of(context).popUntil((_) => count++ >= 2),
          )
        ],
      ),
      body: PasswordlessView(
        email: email,
      ),
    );
  }
}
