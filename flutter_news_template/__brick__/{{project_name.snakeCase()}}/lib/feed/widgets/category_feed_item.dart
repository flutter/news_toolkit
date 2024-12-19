import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/categories/categories.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/newsletter/newsletter.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({required this.block, super.key});

  /// The associated [NewsBlock] instance.
  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    late Widget widget;

    if (newsBlock is DividerHorizontalBlock) {
      widget = DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      widget = Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      widget = SectionHeader(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostLargeBlock) {
      final categoryName = context
          .read<CategoriesBloc>()
          .state
          .getCategoryName(newsBlock.categoryId);
      widget = PostLarge(
        block: newsBlock,
        categoryName: categoryName,
        premiumText: context.l10n.newsBlockPremiumText,
        isLocked: newsBlock.isPremium && !isUserSubscribed,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostMediumBlock) {
      widget = PostMedium(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostSmallBlock) {
      widget = PostSmall(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostGridGroupBlock) {
      final categoryName = context
          .read<CategoriesBloc>()
          .state
          .getCategoryName(newsBlock.categoryId);
      widget = PostGrid(
        gridGroupBlock: newsBlock,
        categoryName: categoryName,
        premiumText: context.l10n.newsBlockPremiumText,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is NewsletterBlock) {
      widget = const Newsletter();
    } else if (newsBlock is BannerAdBlock) {
      widget = BannerAd(
        block: newsBlock,
        adFailedToLoadTitle: context.l10n.adLoadFailure,
      );
    } else {
      // Render an empty widget for the unsupported block type.
      widget = const SizedBox();
    }

    return (newsBlock is! PostGridGroupBlock)
        ? SliverToBoxAdapter(child: widget)
        : widget;
  }

  /// Handles actions triggered by tapping on feed items.
  Future<void> _onFeedItemAction(
    BuildContext context,
    BlockAction action,
  ) async {
    if (action is NavigateToArticleAction) {
      await Navigator.of(context).push<void>(
        ArticlePage.route(id: action.articleId),
      );
    } else if (action is NavigateToVideoArticleAction) {
      await Navigator.of(context).push<void>(
        ArticlePage.route(id: action.articleId, isVideoArticle: true),
      );
    } else if (action is NavigateToFeedCategoryAction) {
      context
          .read<CategoriesBloc>()
          .add(CategorySelected(category: action.category));
    }
  }
}
