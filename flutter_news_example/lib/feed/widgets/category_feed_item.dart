import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/newsletter/newsletter.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({
    super.key,
    required this.block,
  });

  /// The associated [NewsBlock] instance.
  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      return SectionHeader(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostLargeBlock) {
      return PostLarge(
        block: newsBlock,
        premiumText: context.l10n.newsBlockPremiumText,
        isLocked: newsBlock.isPremium && !isUserSubscribed,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostMediumBlock) {
      return PostMedium(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostSmallBlock) {
      return PostSmall(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is PostGridGroupBlock) {
      // TODO(felangel): This widget is a shrink wrap Grid.
      return PostGrid(
        gridGroupBlock: newsBlock,
        premiumText: context.l10n.newsBlockPremiumText,
        onPressed: (action) => _onFeedItemAction(context, action),
      );
    } else if (newsBlock is NewsletterBlock) {
      return const Newsletter();
    } else if (newsBlock is BannerAdBlock) {
      return BannerAd(
        block: newsBlock,
        adFailedToLoadTitle: context.l10n.adLoadFailure,
      );
    } else {
      // Render an empty widget for the unsupported block type.
      return const SizedBox();
    }
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
