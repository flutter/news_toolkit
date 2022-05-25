import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.onChanged,
    required this.controller,
  });

  final ValueSetter<String>? onChanged;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppTextField(
        controller: controller,
        prefix: const Icon(Icons.search),
        suffix: IconButton(
          onPressed: controller.clear,
          icon: const Icon(Icons.clear),
        ),
        hintText: context.l10n.searchByKeyword,
        onChanged: onChanged,
      ),
    );
  }
}
