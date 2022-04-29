import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// An email field component.
class AppEmailField extends StatelessWidget {
  const AppEmailField({
    Key? key,
    this.controller,
    this.hintText,
    this.onSuffixPressed,
    this.suffixVisibility,
    this.onChanged,
  }) : super(key: key);

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// Called when the user clicks on the suffix icon.
  final VoidCallback? onSuffixPressed;

  /// The visibility of the suffix icon.
  final bool? suffixVisibility;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      prefix: const Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.sm,
          right: AppSpacing.sm,
        ),
        child: Icon(
          Icons.email_outlined,
          color: AppColors.mediumEmphasis,
          size: 24,
        ),
      ),
      onChanged: onChanged,
      onSuffixPressed: onSuffixPressed,
      suffixVisibility: suffixVisibility,
    );
  }
}
