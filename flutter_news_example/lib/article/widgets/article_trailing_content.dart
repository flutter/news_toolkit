import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles =
        context.select((ArticleBloc bloc) => bloc.state.relatedArticles);
    final isArticlePreview =
        context.select((ArticleBloc bloc) => bloc.state.isPreview);

    final hasReachedArticleViewsLimit = context
        .select((ArticleBloc bloc) => bloc.state.hasReachedArticleViewsLimit);
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    final isArticlePremium =
        context.select((ArticleBloc bloc) => bloc.state.isPremium);

    final showSubscribeWithArticleLimitModal =
        hasReachedArticleViewsLimit && !isUserSubscribed;

    final showSubscribeModal = isArticlePremium && !isUserSubscribed;

    return MultiSliver(
      children: [
        if (relatedArticles.isNotEmpty && !isArticlePreview) ...[
          SliverPadding(
            padding: const EdgeInsets.only(
              top: AppSpacing.xlg,
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                context.l10n.relatedStories,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
          ...relatedArticles.map(
            (articleBlock) => CategoryFeedItem(block: articleBlock),
          ),
        ],
        if (!isArticlePreview) ...[
          const SliverPadding(
            padding: EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: ArticleComments()),
          )
        ],
        if (isArticlePreview) ...[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: AppSpacing.xlg),
                if (showSubscribeModal)
                  const SubscribeModal()
                else if (showSubscribeWithArticleLimitModal)
                  const SubscribeWithArticleLimitModal(),
              ],
            ),
          ),
        ]
      ],
    );
  }
}

@visibleForTesting
class ArticleTrailingShadow extends StatelessWidget {
  const ArticleTrailingShadow({super.key});

  static const _gradientHeight = 256.0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -_gradientHeight,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            height: _gradientHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.white.withOpacity(0),
                  AppColors.white.withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
