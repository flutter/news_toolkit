import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBackButtonPage extends StatefulWidget {
  const AppBackButtonPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const AppBackButtonPage());
  }

  @override
  State<AppBackButtonPage> createState() => _AppBackButtonPageState();
}

class _AppBackButtonPageState extends State<AppBackButtonPage> {
  bool _isLight = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isLight ? AppColors.grey : AppColors.white,
      appBar: AppBar(
        title: const Text('App back button'),
        leading: _isLight ? const AppBackButton.light() : const AppBackButton(),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: _isLight,
              onChanged: (_) => setState(() => _isLight = !_isLight),
            ),
            const Text('Default/light'),
          ],
        ),
      ),
    );
  }
}
