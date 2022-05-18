import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const FeedState.initial()) {
    on<FeedRequested>(_onFeedRequested);
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onFeedRequested(
    FeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    try {
      final category = event.category;
      final categoryFeed = state.feed[category] ?? [];

      final response = await _newsRepository.getFeed(
        category: category,
        offset: categoryFeed.length,
      );

      // Append fetched feed blocks to the list of feed blocks
      // for the given category.
      final updatedCategoryFeed = [...categoryFeed, ...response.feed];
      final hasMoreNewsForCategory =
          response.totalCount > updatedCategoryFeed.length;

      emit(
        state.copyWith(
          status: FeedStatus.populated,
          feed: Map<Category, List<NewsBlock>>.from(state.feed)
            ..addAll({category: updatedCategoryFeed}),
          hasMoreNews: Map<Category, bool>.from(state.hasMoreNews)
            ..addAll({category: hasMoreNewsForCategory}),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FeedStatus.failure));
      addError(error, stackTrace);
    }
  }
}
