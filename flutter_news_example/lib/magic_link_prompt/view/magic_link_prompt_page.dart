import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/magic_link_prompt/magic_link_prompt.dart';
import 'package:go_router/go_router.dart';

class MagicLinkPromptPage extends StatelessWidget {
  const MagicLinkPromptPage({required this.email, super.key});

  static const routePath = 'magic-link-prompt';

  final String email;

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) {
    final email = state.uri.queryParameters['email']!;
    return MagicLinkPromptPage(email: email);
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
