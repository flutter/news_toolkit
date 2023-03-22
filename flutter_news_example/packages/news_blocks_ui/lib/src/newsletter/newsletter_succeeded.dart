import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

/// {@template newsletter_success}
/// A reusable newsletter success news block widget.
/// {@endtemplate}
class NewsletterSucceeded extends StatelessWidget {
  /// {@macro newsletter_success}
  const NewsletterSucceeded({
    required this.headerText,
    required this.content,
    required this.footerText,
    super.key,
  });

  /// The header displayed message.
  final String headerText;

  /// The widget displayed in a center of [NewsletterSucceeded] view.
  final Widget content;

  /// The footer displayed message.
  final String footerText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NewsletterContainer(
      child: Column(
        children: [
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.highEmphasisPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          content,
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          Text(
            footerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.mediumHighEmphasisPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
