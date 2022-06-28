import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

/// {@template slideshow}
/// A reusable slideshow.
/// {@endtemplate}
class Slideshow extends StatefulWidget {
  /// {@macro slideshow}
  const Slideshow({
    super.key,
    required this.block,
    required this.categoryTitle,
  });

  /// The associated [SlideshowBlock] instance.
  final SlideshowBlock block;

  /// The title of the category.
  final String categoryTitle;

  @override
  State<Slideshow> createState() => _SlideshowState();
}

class _SlideshowState extends State<Slideshow> {
  final _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlideshowCategoryTitle(
            title: widget.categoryTitle,
          ),
          _SlideshowHeaderTitle(title: widget.block.title),
          _SlideshowPageView(
            slides: widget.block.slides,
            controller: _controller,
          ),
          _SlideshowButtons(
            totalPages: widget.block.slides.length,
            controller: _controller,
          ),
          const SizedBox(height: AppSpacing.lg)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _SlideshowCategoryTitle extends StatelessWidget {
  const _SlideshowCategoryTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg),
      child: SlideshowCategory(
        inIntroduction: false,
        slideshowText: title,
      ),
    );
  }
}

class _SlideshowHeaderTitle extends StatelessWidget {
  const _SlideshowHeaderTitle({
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Text(
        title,
        style: theme.headline4?.apply(
          color: AppColors.highEmphasisPrimary,
        ),
      ),
    );
  }
}

class _SlideshowPageView extends StatelessWidget {
  const _SlideshowPageView({
    required this.slides,
    required this.controller,
  });

  /// List of slides to be displayed.
  final List<SlideBlock> slides;

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: controller,
        itemCount: slides.length,
        itemBuilder: (contex, index) => _SlidehowItem(
          slide: slides[index],
        ),
      ),
    );
  }
}

class _SlidehowItem extends StatelessWidget {
  const _SlidehowItem({
    required this.slide,
  });

  final SlideBlock slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.square(
          child: Image.network(slide.imageUrl),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Text(
            slide.caption,
            style: theme.headline6?.apply(
              color: AppColors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.lg,
          ),
          child: Text(
            slide.description,
            style: theme.caption?.apply(
              color: AppColors.mediumHighEmphasisPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.xxxs,
          ),
          child: Text(
            slide.photoCredit,
            style: theme.caption?.apply(
              color: AppColors.mediumEmphasisPrimary,
            ),
          ),
        )
      ],
    );
  }
}

class _SlideshowButtons extends StatefulWidget {
  const _SlideshowButtons({
    required this.totalPages,
    required this.controller,
  });

  final int totalPages;
  final PageController controller;

  @override
  State<_SlideshowButtons> createState() => _SlideshowButtonsState();
}

class _SlideshowButtonsState extends State<_SlideshowButtons> {
  int _currentPage = 0;
  static const _pageAnimationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    widget.controller.addListener(_onPageChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            if (_currentPage >= 1) {
              widget.controller.previousPage(
                duration: _pageAnimationDuration,
                curve: Curves.easeInOut,
              );
            }
          },
          icon: const Icon(Icons.arrow_back),
          color: _currentPage == 0 ? AppColors.grey : AppColors.white,
        ),
        Text(
          '${_currentPage + 1} of ${widget.totalPages}',
          style: theme.textTheme.headline6?.apply(color: AppColors.white),
        ),
        IconButton(
          onPressed: () {
            if (_currentPage < widget.totalPages - 1) {
              widget.controller.nextPage(
                duration: _pageAnimationDuration,
                curve: Curves.easeInOut,
              );
            }
          },
          icon: Icon(
            Icons.arrow_forward,
            color: _currentPage == widget.totalPages - 1
                ? AppColors.grey
                : AppColors.white,
          ),
        ),
      ],
    );
  }

  void _onPageChanged() {
    setState(() {
      _currentPage = widget.controller.page?.toInt() ?? 0;
    });
  }
}
