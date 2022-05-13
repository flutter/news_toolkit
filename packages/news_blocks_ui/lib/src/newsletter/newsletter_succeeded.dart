import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

/// {@template newsletter_success}
/// A reusable newsletter success news block widget.
/// {@endtemplate}
class NewsletterSuccess extends StatelessWidget {
  /// {@macro newsletter_success}
  const NewsletterSuccess({
    super.key,
    required this.header,
    required this.center,
    required this.footer,
  });

  /// The header displayed message.
  final String header;

  /// The widget displayed in a center of [NewsletterSuccess] view.
  final Widget center;

  /// The footer displayed message.
  final String footer;

  @override
  Widget build(BuildContext context) {
    return NewsletterContainer(
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: AppColors.highEmphasisPrimary,
                ),
          ),
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          center,
          const SizedBox(height: AppSpacing.lg + AppSpacing.lg),
          Text(
            footer,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: AppColors.mediumHighEmphasisPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
