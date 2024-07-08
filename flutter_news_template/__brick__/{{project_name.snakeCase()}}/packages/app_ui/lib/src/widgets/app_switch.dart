import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_switch}
/// Switch with optional leading text displayed in the application.
/// {@endtemplate}
class AppSwitch extends StatelessWidget {
  /// {@macro app_switch}
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.onText = '',
    this.offText = '',
    super.key,
  });

  /// Text displayed when this switch is set to true.
  ///
  /// Defaults to an empty string.
  final String onText;

  /// Text displayed when this switch is set to false.
  ///
  /// Defaults to an empty string.
  final String offText;

  /// Whether this checkbox is checked.
  final bool value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ContentThemeOverrideBuilder(
          builder: (context) => Text(
            value ? onText : offText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.eerieBlack,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
