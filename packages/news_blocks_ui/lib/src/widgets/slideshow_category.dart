import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template slideshow_category}
/// A widget displaying a slideshow category.
/// {@endtemplate}
class SlideshowCategory extends StatelessWidget {
  /// {@macro slideshow_category}
  const SlideshowCategory({
    super.key,
    required this.slideshowText,
    this.inIntroduction = true,
  });

  /// Boolean which tracks if slideshow category is
  /// being displayed in an introduction.
  final bool inIntroduction;

  /// Text displayed in the slideshow category widget.
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        inIntroduction ? AppColors.secondary : AppColors.transparent;
    final textColor = inIntroduction ? AppColors.white : AppColors.orange;
    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                horizontalSpacing,
                0,
                horizontalSpacing,
                AppSpacing.xxs,
              ),
              child: Text(
                slideshowText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .overline
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
