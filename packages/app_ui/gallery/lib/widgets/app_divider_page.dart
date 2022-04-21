import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppDividerPage extends StatelessWidget {
  const AppDividerPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppDividerPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divider'),
      ),
      body: const ColoredBox(
        color: AppColors.darkBackground,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: AppDivider(),
          ),
        ),
      ),
    );
  }
}
