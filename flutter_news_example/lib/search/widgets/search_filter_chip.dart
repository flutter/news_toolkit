import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchFilterChip extends StatelessWidget {
  const SearchFilterChip({
    required this.chipText,
    required this.onSelected,
    super.key,
  });

  final ValueSetter<String> onSelected;

  final String chipText;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs + AppSpacing.xxs,
      ),
      label: Text(
        chipText,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      onSelected: (_) => onSelected(chipText),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.borderOutline),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
    );
  }
}
