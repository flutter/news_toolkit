import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template post_footer}
/// The reusable footer of a post news block widget.
/// {@endtemplate}
class PostFooter extends StatelessWidget {
  /// {@macro post_footer}
  const PostFooter({
    Key? key,
    required this.publishedAt,
    this.author,
    this.onShare,
  }) : super(key: key);

  /// The author of this post.
  final String? author;

  /// The date when this post was published.
  final DateTime publishedAt;

  /// Called when the share button is tapped.
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DefaultTextStyle(
          style: textTheme.caption!.copyWith(
            color: AppColors.mediumEmphasisSurface,
          ),
          child: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                if (author != null) ...[
                  TextSpan(
                    text: author,
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
                  TextSpan(
                    text: '•',
                    style: DefaultTextStyle.of(context).style,
                  ),
                  const WidgetSpan(child: SizedBox(width: AppSpacing.sm)),
                ],
                TextSpan(
                  text: publishedAt.mDY,
                  style: DefaultTextStyle.of(context).style,
                ),
              ],
            ),
          ),
        ),
        if (onShare != null)
          IconButton(
            icon: const Icon(
              Icons.share,
              color: AppColors.mediumEmphasisSurface,
            ),
            onPressed: onShare,
          ),
      ],
    );
  }
}
