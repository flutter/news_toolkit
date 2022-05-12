import 'package:flutter/material.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/magic_link_prompt/magic_link_prompt.dart';

class MagicLinkPromptPage extends StatelessWidget {
  const MagicLinkPromptPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  static Route route({
    required String email,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => MagicLinkPromptPage(
          email: email,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: const Key('magicLinkPrompt_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.settings.name == LoginPage.name),
          )
        ],
      ),
      body: MagicLinkPromptView(
        email: email,
      ),
    );
  }
}
