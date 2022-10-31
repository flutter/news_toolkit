import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppLogoPage extends StatelessWidget {
  const AppLogoPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AppLogoPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logo'),
      ),
      body: ColoredBox(
        color: AppColors.darkBackground,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppLogo.dark(),
              const SizedBox(height: AppSpacing.lg),
              AppLogo.light(),
            ],
          ),
        ),
      ),
    );
  }
}
