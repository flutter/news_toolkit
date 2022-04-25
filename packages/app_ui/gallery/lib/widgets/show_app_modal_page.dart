import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ShowAppModalPage extends StatelessWidget {
  const ShowAppModalPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ShowAppModalPage());
  }

  @override
  Widget build(BuildContext context) {
    const _contentSpace = 10.0;
    final buttons = [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ElevatedButton(
          onPressed: () => _showModal(context: context),
          style: ElevatedButton.styleFrom(
            primary: AppColors.oceanBlue,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxlg + _contentSpace,
              vertical: AppSpacing.xlg,
            ),
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Show app modal'),
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

  void _showModal({
    required BuildContext context,
  }) {
    showAppModal<void>(
      context: context,
      backgroundColor: AppColors.modalBackground,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 300,
            color: AppColors.darkAqua,
            alignment: Alignment.center,
          ),
          Container(
            height: 200,
            color: AppColors.blue,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}
