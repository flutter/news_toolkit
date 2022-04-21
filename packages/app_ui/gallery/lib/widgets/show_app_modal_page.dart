import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ShowAppModalPage extends StatelessWidget {
  const ShowAppModalPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ShowAppModalPage());
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ElevatedButton(
          onPressed: () => showModal(context: context, maxHeight: 500),
          style: ElevatedButton.styleFrom(
            primary: AppColors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Login size modal'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ElevatedButton(
          onPressed: () => showModal(context: context, maxHeight: 330),
          style: ElevatedButton.styleFrom(
            primary: AppColors.red,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Subscribe size modal'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ElevatedButton(
          onPressed: () => showModal(context: context, maxHeight: 386),
          style: ElevatedButton.styleFrom(
            primary: AppColors.oceanBlue,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Limit article size modal'),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modal App'),
      ),
      body: ColoredBox(
        color: AppColors.white,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          ),
        ),
      ),
    );
  }

  void showModal({
    required BuildContext context,
    required double maxHeight,
  }) {
    showAppModal<void>(
      context: context,
      constraints: BoxConstraints(maxHeight: maxHeight),
      backgroundColor: AppColors.modalBackground,
      builder: (context) => Container(
        alignment: Alignment.center,
        child: Text(
          'Max Size: $maxHeight',
          style: AppTextStyle.headline3,
        ),
      ),
    );
  }
}
