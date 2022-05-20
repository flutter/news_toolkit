import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc({
    required String articleId,
    required NewsRepository newsRepository,
  })  : _articleId = articleId,
        _newsRepository = newsRepository,
        super(const ArticleState.initial()) {
    on<ArticleRequested>(_onArticleRequested);
  }

  final String _articleId;
  final NewsRepository _newsRepository;

  FutureOr<void> _onArticleRequested(
    ArticleRequested event,
    Emitter<ArticleState> emit,
  ) async {
    emit(state.copyWith(status: ArticleStatus.loading));
    try {
      final response = await _newsRepository.getArticle(
        id: _articleId,
        offset: state.content.length,
      );

      // Append fetched article content blocks to the list of content blocks.
      final updatedContent = [...state.content, ...response.content];
      final hasMoreContent = response.totalCount > updatedContent.length;

      emit(
        state.copyWith(
          status: ArticleStatus.populated,
          content: updatedContent,
          hasMoreContent: hasMoreContent,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: ArticleStatus.failure));
      addError(error, stackTrace);
    }
  }
}
