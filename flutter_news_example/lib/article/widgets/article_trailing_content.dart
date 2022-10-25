import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_template/app/app.dart';
import 'package:flutter_news_template/article/article.dart';
import 'package:flutter_news_template/feed/feed.dart';
import 'package:flutter_news_template/l10n/l10n.dart';
import 'package:flutter_news_template/subscriptions/subscriptions.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles =
        context.select((ArticleBloc bloc) => bloc.state.relatedArticles);

    final hasReachedArticleViewsLimit = context
        .select((ArticleBloc bloc) => bloc.state.hasReachedArticleViewsLimit);
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);
    final isArticlePreview =
        context.select((ArticleBloc bloc) => bloc.state.isPreview);
    final isArticlePremium =
        context.select((ArticleBloc bloc) => bloc.state.isPremium);

    final showSubscribeWithArticleLimitModal =
        hasReachedArticleViewsLimit && !isUserSubscribed;

    final showSubscribeModal = isArticlePremium && !isUserSubscribed;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SafeArea(
          bottom: !isArticlePreview,
          child: Column(
            key: const Key('articleTrailingContent_column'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (relatedArticles.isNotEmpty && !isArticlePreview) ...[
                const SizedBox(height: AppSpacing.xlg),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Text(
                    context.l10n.relatedStories,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ...relatedArticles.map(
                  (articleBlock) => CategoryFeedItem(block: articleBlock),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (!isArticlePreview) ...[
                const SizedBox(height: AppSpacing.xlg),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: ArticleComments(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (isArticlePreview) ...[
                const SizedBox(height: AppSpacing.xlg),
                if (showSubscribeModal)
                  const SubscribeModal()
                else if (showSubscribeWithArticleLimitModal)
                  const SubscribeWithArticleLimitModal(),
              ],
            ],
          ),
        ),
        if (isArticlePreview) const ArticleTrailingShadow(),
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
