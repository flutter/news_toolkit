import 'package:flutter/material.dart';
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
    var count = 0;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            key: const Key('magicLinkPrompt_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () =>
                Navigator.of(context).popUntil((_) => count++ >= 2),
          )
        ],
      ),
      body: MagicLinkPromptView(
        email: email,
      ),
    );
  }
}
