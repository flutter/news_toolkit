import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SpacingPage extends StatelessWidget {
  const SpacingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const SpacingPage());
  }

  @override
  Widget build(BuildContext context) {
    const spacingList = [
      _SpacingItem(spacing: AppSpacing.xxxs, name: 'xxxs'),
      _SpacingItem(spacing: AppSpacing.xxs, name: 'xxs'),
      _SpacingItem(spacing: AppSpacing.xs, name: 'xs'),
      _SpacingItem(spacing: AppSpacing.sm, name: 'sm'),
      _SpacingItem(spacing: AppSpacing.md, name: 'md'),
      _SpacingItem(spacing: AppSpacing.lg, name: 'lg'),
      _SpacingItem(spacing: AppSpacing.xlg, name: 'xlg'),
      _SpacingItem(spacing: AppSpacing.xxlg, name: 'xxlg'),
      _SpacingItem(spacing: AppSpacing.xxxlg, name: 'xxxlg'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Spacing')),
      body: ListView.builder(
        itemCount: spacingList.length,
        itemBuilder: (_, index) => spacingList[index],
      ),
    );
  }
}

class _SpacingItem extends StatelessWidget {
  const _SpacingItem({required this.spacing, required this.name});

  final double spacing;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: AppColors.black,
                width: AppSpacing.xxs,
                height: AppSpacing.lg,
              ),
              Container(
                width: spacing,
                height: AppSpacing.lg,
                color: AppColors.green,
              ),
              Container(
                color: AppColors.black,
                width: AppSpacing.xxs,
                height: AppSpacing.lg,
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(name),
        ],
      ),
    );
  }
}
