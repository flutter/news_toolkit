import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template slideshow_introduction}
/// A reusable slideshow introduction news block widget.
/// {@endtemplate}
class SlideshowIntroduction extends StatelessWidget {
  /// {@macro slideshow_introduction}
  const SlideshowIntroduction({
    required this.block,
    required this.slideshowText,
    this.onPressed,
    super.key,
  });

  /// The associated [SlideshowIntroductionBlock] instance.
  final SlideshowIntroductionBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  /// Text displayed in the slideshow category widget.
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final action = block.action;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () {
          if (action != null) onPressed?.call(action);
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            PostLargeImage(
              imageUrl: block.coverImageUrl,
              isContentOverlaid: true,
              isLocked: false,
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SlideshowCategory(slideshowText: slideshowText),
                  const SizedBox(
                    height: AppSpacing.xs,
                  ),
                  Text(
                    block.title,
                    style: textTheme.displayMedium?.copyWith(
                      color: AppColors.highEmphasisPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
