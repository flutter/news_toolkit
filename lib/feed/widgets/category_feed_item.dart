import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/newsletter/newsletter.dart';
import 'package:google_news_template/subscribe/widgets/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class CategoryFeedItem extends StatelessWidget {
  const CategoryFeedItem({super.key, required this.block});

  /// The associated [NewsBlock] instance.
  final NewsBlock block;

  @override
  Widget build(BuildContext context) {
    final newsBlock = block;

    if (newsBlock is DividerHorizontalBlock) {
      return DividerHorizontal(block: newsBlock);
    } else if (newsBlock is SpacerBlock) {
      return Spacer(block: newsBlock);
    } else if (newsBlock is SectionHeaderBlock) {
      return SectionHeader(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action, newsBlock),
      );
    } else if (newsBlock is PostLargeBlock) {
      return PostLarge(
        block: newsBlock,
        premiumText: context.l10n.newsBlockPremiumText,
        onPressed: (action) => _onFeedItemAction(context, action, newsBlock),
      );
    } else if (newsBlock is PostMediumBlock) {
      return PostMedium(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action, newsBlock),
      );
    } else if (newsBlock is PostSmallBlock) {
      return PostSmall(
        block: newsBlock,
        onPressed: (action) => _onFeedItemAction(context, action, newsBlock),
      );
    } else if (newsBlock is PostGridGroupBlock) {
      return PostGrid(
        gridGroupBlock: newsBlock,
        premiumText: context.l10n.newsBlockPremiumText,
        onPressed: (action) => _onFeedItemAction(context, action, newsBlock),
      );
    } else if (newsBlock is NewsletterBlock) {
      return const Newsletter();
    } else if (newsBlock is BannerAdBlock) {
      return BannerAd(block: newsBlock);
    } else {
      // Render an empty widget for the unsupported block type.
      return const SizedBox();
    }
  }

  /// Handles actions triggered by tapping on feed items.
  Future<void> _onFeedItemAction(
    BuildContext context,
    BlockAction action,
    NewsBlock newsBlock,
  ) async {
    if (newsBlock is PostBlock && newsBlock.isPremium) {
      // TODO(ana): we need to validate if user is premium, now is always true
      await showAppModal<void>(
        context: context,
        builder: (context) => const SubscribeLoggedInModal(),
      );
    } else if (action is NavigateToArticleAction) {
      await Navigator.of(context).push<void>(
        ArticlePage.route(id: action.articleId),
      );
    } else if (action is NavigateToFeedCategoryAction) {
      context
          .read<CategoriesBloc>()
          .add(CategorySelected(category: action.category));
    }
  }
}
