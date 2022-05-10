import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// An email text field component.
class AppEmailTextField extends StatelessWidget {
  const AppEmailTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.emailAddress,
      autoFillHints: const [AutofillHints.email],
      autocorrect: false,
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
      onChanged: onChanged,
      suffix: suffix,
    );
  }
}
