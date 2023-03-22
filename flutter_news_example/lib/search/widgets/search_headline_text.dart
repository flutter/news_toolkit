import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchHeadlineText extends StatelessWidget {
  const SearchHeadlineText({required this.headerText, super.key});

  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        headerText.toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.secondary,
            ),
      ),
    );
  }
}
