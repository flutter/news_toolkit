import 'dart:async';

import 'package:article_repository/article_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:news_blocks/news_blocks.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc({
    required String articleId,
    required ArticleRepository articleRepository,
  })  : _articleId = articleId,
        _articleRepository = articleRepository,
        super(const ArticleState.initial()) {
    on<ArticleRequested>(_onArticleRequested);
  }

  final String _articleId;
  final ArticleRepository _articleRepository;

  /// The number of articles the user may view without being a subscriber.
  static const _articleViewsLimit = 4;

  /// The duration after which the number of article views will be reset.
  static const _resetArticleViewsAfterDuration = Duration(days: 1);

  ///The number of related articles the user may view in the article.
  static const _relatedArticlesLimit = 5;

  FutureOr<void> _onArticleRequested(
    ArticleRequested event,
    Emitter<ArticleState> emit,
  ) async {
    final isInitialRequest = state.status == ArticleStatus.initial;

    try {
      emit(state.copyWith(status: ArticleStatus.loading));

      if (isInitialRequest) {
        await _updateArticleViews();
      }

      final hasReachedArticleViewsLimit = await _hasReachedArticleViewsLimit();

      final response = await _articleRepository.getArticle(
        id: _articleId,
        offset: state.content.length,
      );

      // Append fetched article content blocks to the list of content blocks.
      final updatedContent = [...state.content, ...response.content];
      final hasMoreContent = response.totalCount > updatedContent.length;

      RelatedArticlesResponse? relatedArticlesResponse;
      if (!hasMoreContent && state.relatedArticles.isEmpty) {
        relatedArticlesResponse = await _articleRepository.getRelatedArticles(
          id: _articleId,
          limit: _relatedArticlesLimit,
        );
      }

      emit(
        state.copyWith(
          status: ArticleStatus.populated,
          content: updatedContent,
          relatedArticles: relatedArticlesResponse?.relatedArticles ?? [],
          hasMoreContent: hasMoreContent,
          hasReachedArticleViewsLimit: hasReachedArticleViewsLimit,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ArticleStatus.failure));
      addError(error, stackTrace);
    }
  }

  /// Resets the number of article views if the counter was never reset or if
  /// the counter was reset more than [_resetArticleViewsAfterDuration] ago.
  ///
  /// After, increments the total number of article views by 1.
  Future<void> _updateArticleViews() async {
    final currentArticleViews = await _articleRepository.fetchArticleViews();
    final resetAt = currentArticleViews.resetAt;

    final now = clock.now();
    final shouldResetArticleViews = resetAt == null ||
        now.isAfter(resetAt.add(_resetArticleViewsAfterDuration));

    if (shouldResetArticleViews) {
      await _articleRepository.resetArticleViews();
    }

    await _articleRepository.incrementArticleViews();
  }

  /// Returns whether the user has reached the limit of article views.
  Future<bool> _hasReachedArticleViewsLimit() async {
    final currentArticleViews = await _articleRepository.fetchArticleViews();
    return currentArticleViews.views >= _articleViewsLimit;
  }
}
