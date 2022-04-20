import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_divider}
/// A default app divider.
/// {@endtemplate}
class AppDivider extends StatelessWidget {
  /// {@macro app_divider}
  const AppDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      endIndent: 0,
      indent: 0,
      height: 16,
      color: AppColors.darkOnBackground.withOpacity(0.16),
    );
  }
}
