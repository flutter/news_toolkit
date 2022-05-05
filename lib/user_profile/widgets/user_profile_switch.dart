import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

class UserProfileSwitch extends StatelessWidget {
  const UserProfileSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// Whether this checkbox is checked.
  final bool value;

  /// Called when the value of the checkbox should change.
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value
              ? l10n.userProfileCheckboxOnTitle
              : l10n.userProfileCheckboxOffTitle,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxs,
          ),
          child: Switch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
