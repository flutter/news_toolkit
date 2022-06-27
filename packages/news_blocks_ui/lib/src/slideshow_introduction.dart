import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/slideshow_category.dart';

/// {@template post_large}
/// A reusable slideshow introduction.
/// {@endtemplate}
class SlideshowIntroduction extends StatelessWidget {
  /// {@macro slideshow_introduction}
  const SlideshowIntroduction({
    super.key,
    required this.block,
    required this.slideshowText,
    this.onPressed,
  });

  /// The associated [SlideshowIntroductionBlock] instance.
  final SlideshowIntroductionBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  /// Text displayed in the slideshow category widget
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    const isContentOverlaid = true;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: GestureDetector(
        onTap: () => onPressed?.call(block.action!),
        child: Stack(
          key: const Key('slideshow_introduction_stack'),
          alignment: Alignment.bottomLeft,
          children: [
            PostLargeImage(
              imageUrl: block.coverImageUrl,
              isContentOverlaid: isContentOverlaid,
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
                    style: textTheme.headline2?.copyWith(
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
