import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_text_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
///
/// * [AppEmailField]
/// {@endtemplate}
class AppTextField extends StatelessWidget {
  /// {@macro app_text_field}
  const AppTextField({
    Key? key,
    this.initialValue,
    this.controller,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onTap,
  }) : super(key: key);

  /// A value to initialize the field to.
  final String? initialValue;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user initiates a change to the TextField's
  /// value: when they have inserted or deleted text.
  final ValueChanged<String>? onChanged;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 80),
          child: TextFormField(
            key: key,
            initialValue: initialValue,
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            autocorrect: autocorrect,
            readOnly: readOnly,
            cursorColor: AppColors.black.withOpacity(0.4),
            style: AppTextStyle.headline6.copyWith(
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              // TODO(ana): change later with the new colors
              fillColor: AppColors.textFieldBackground.withOpacity(0.08),
              contentPadding: const EdgeInsets.all(AppSpacing.lg),
              errorText: errorText,
              prefixIcon: prefix,
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints.tightFor(
                width: 32,
                height: 32,
              ),
              prefixIconConstraints: const BoxConstraints.tightFor(
                width: 48,
              ),
            ),
            onChanged: onChanged,
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}

/// {@template app_email_field}
/// An email field component based on [AppTextField] widget.
/// {@endtemplate}
class AppEmailField extends StatelessWidget {
  /// {@macro app_email_field}
  const AppEmailField({
    Key? key,
    this.controller,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.onChanged,
  }) : super(key: key);

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears before the editable part of the text field when
  /// the value is changed.
  final Widget? suffix;

  /// Called when the user initiates a change to the TextField's
  /// value: when they have inserted or deleted text.
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      prefix: prefix,
      suffix: suffix,
      onChanged: onChanged,
    );
  }
}
