import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppTextFieldPage extends StatefulWidget {
  const AppTextFieldPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppTextFieldPage());
  }

  @override
  State<AppTextFieldPage> createState() => _AppTextFieldPageState();
}

class _AppTextFieldPageState extends State<AppTextFieldPage> {
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
        child: AppEmailField(
          hintText: 'Your email address',
          onChanged: (_) {},
          suffixOpacity: 1,
          onSuffixPressed: () {},
        ),
      ),
    );
  }
}
