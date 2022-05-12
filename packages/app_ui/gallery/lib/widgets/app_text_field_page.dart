import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppTextFieldPage extends StatelessWidget {
  const AppTextFieldPage({super.key});

  static Route route() {
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
        child: AppTextField(
          hintText: 'Your email address',
          onChanged: (_) {},
          prefix: const Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
            ),
            child: Icon(
              Icons.email_outlined,
              color: AppColors.mediumEmphasisSurface,
              size: 24,
            ),
          ),
          suffix: Padding(
            key: const Key('appTextField_suffixIcon'),
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Visibility(
              child: GestureDetector(
                onTap: () {},
                child: Assets.icons.closeCircle.svg(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
