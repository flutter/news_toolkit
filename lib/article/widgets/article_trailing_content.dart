import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';

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

    final showSubscribeWithArticleLimitModal =
        hasReachedArticleViewsLimit && !isUserSubscribed;

    final isArticleContentObscured = showSubscribeWithArticleLimitModal;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SafeArea(
          bottom: !showSubscribeWithArticleLimitModal,
          child: Column(
            key: const Key('articleTrailingContent_column'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (relatedArticles.isNotEmpty &&
                  !showSubscribeWithArticleLimitModal) ...[
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
              ],
              if (!showSubscribeWithArticleLimitModal) ...[
                if (relatedArticles.isNotEmpty)
                  const SizedBox(height: AppSpacing.lg),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: ArticleComments(),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (showSubscribeWithArticleLimitModal) ...[
                const SizedBox(height: AppSpacing.lg),
                const SubscribeWithArticleLimitModal(),
              ],
            ],
          ),
        ),
        if (isArticleContentObscured) const ArticleTrailingShadow(),
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
