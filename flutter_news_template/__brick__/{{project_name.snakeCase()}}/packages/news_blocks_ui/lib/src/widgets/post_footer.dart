import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_footer}
/// A reusable footer of a post news block widget.
/// {@endtemplate}
class PostFooter extends StatelessWidget {
  /// {@macro post_footer}
  const PostFooter({
    super.key,
    this.publishedAt,
    this.author,
    this.onShare,
    this.isContentOverlaid = false,
  });

  /// The author of this post.
  final String? author;

  /// The date when this post was published.
  final DateTime? publishedAt;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  /// Whether footer is displayed in reversed color theme.
  ///
  /// Defaults to false.
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = isContentOverlaid
        ? AppColors.mediumHighEmphasisPrimary
        : AppColors.mediumEmphasisSurface;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(color: textColor),
            children: <InlineSpan>[
              if (author != null)
                TextSpan(
                  text: author,
                ),
              if (author != null && publishedAt != null) ...[
                const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
                const TextSpan(
                  text: '•',
                ),
                const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
              ],
              if (publishedAt != null)
                TextSpan(
                  text: publishedAt!.mDY,
                ),
            ],
          ),
        ),
        if (onShare != null)
          IconButton(
            icon: Icon(
              Icons.share,
              color: textColor,
            ),
            onPressed: onShare,
          ),
      ],
    );
  }
}
