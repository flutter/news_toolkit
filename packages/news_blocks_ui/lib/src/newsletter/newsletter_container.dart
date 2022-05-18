import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template newsletter_container}
/// A reusable newsletter container widget.
/// {@endtemplate}
class NewsletterContainer extends StatelessWidget {
  /// {@macro newsletter_container}
  const NewsletterContainer({
    super.key,
    this.child,
  });

  /// The widget displayed in newsletter container.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ColoredBox(
        color: AppColors.secondary.shade800,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xlg + AppSpacing.sm),
          child: child,
        ),
      ),
    );
  }
}
