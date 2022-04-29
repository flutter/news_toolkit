import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppTextFieldPage extends StatelessWidget {
  const AppTextFieldPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppTextFieldPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TextField',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppTextField(
          hintText: 'Your email address',
          onChanged: (_) {},
        ),
      ),
    );
  }
}
