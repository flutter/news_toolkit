import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBackButtonPage extends StatelessWidget {
  const AppBackButtonPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppBackButtonPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App back button'),
        leading: const AppBackButton(),
      ),
      body: Container(),
    );
  }
}
