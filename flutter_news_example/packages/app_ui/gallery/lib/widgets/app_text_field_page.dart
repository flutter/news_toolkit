import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppTextFieldPage extends StatelessWidget {
  const AppTextFieldPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AppTextFieldPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Field',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const AppEmailTextField(),
            AppTextField(
              hintText: 'Default text field',
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
