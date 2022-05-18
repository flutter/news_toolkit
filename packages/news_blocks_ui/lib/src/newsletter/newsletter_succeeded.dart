import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

/// {@template newsletter_success}
/// A reusable newsletter success news block widget.
/// {@endtemplate}
class NewsletterSucceeded extends StatelessWidget {
  /// {@macro newsletter_success}
  const NewsletterSucceeded({
    super.key,
    required this.header,
    required this.content,
    required this.footer,
  });

  /// The header displayed message.
  final String header;

  /// The widget displayed in a center of [NewsletterSucceeded] view.
  final Widget content;

  /// The footer displayed message.
  final String footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NewsletterContainer(
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline4?.copyWith(
              color: AppColors.highEmphasisPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          content,
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          Text(
            footer,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText1?.copyWith(
              color: AppColors.mediumHighEmphasisPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
