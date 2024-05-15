import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template lock_icon}
/// Reusable lock icon.
/// {@endtemplate}
class LockIcon extends StatelessWidget {
  /// {@macro lock_icon}
  const LockIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Icon(
          Icons.lock,
          size: AppSpacing.xlg,
          color: AppColors.white,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
            Shadow(
              color: Colors.black.withOpacity(0.15),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }
}
