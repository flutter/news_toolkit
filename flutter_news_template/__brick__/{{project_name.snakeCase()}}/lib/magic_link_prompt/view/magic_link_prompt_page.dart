import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:{{project_name.snakeCase()}}/magic_link_prompt/magic_link_prompt.dart';

class MagicLinkPromptPage extends StatelessWidget {
  const MagicLinkPromptPage({required this.email, super.key});

  final String email;

  static Route<void> route({required String email}) {
    return MaterialPageRoute<void>(
      builder: (_) => MagicLinkPromptPage(email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        actions: [
          IconButton(
            key: const Key('magicLinkPrompt_closeIcon'),
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.settings.name == LoginModal.name),
          ),
        ],
      ),
      body: MagicLinkPromptView(
        email: email,
      ),
    );
  }
}
