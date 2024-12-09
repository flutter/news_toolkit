import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

part 'feed_bloc.g.dart';
part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends HydratedBloc<FeedEvent, FeedState> {
  FeedBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const FeedState.initial()) {
    on<FeedRequested>(_onFeedRequested, transformer: sequential());
    on<FeedRefreshRequested>(
      _onFeedRefreshRequested,
      transformer: droppable(),
    );
    on<FeedResumed>(_onFeedResumed, transformer: droppable());
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onFeedRequested(
    FeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));
    return _updateFeed(categoryId: event.category.id, emit: emit);
  }

  FutureOr<void> _onFeedResumed(
    FeedResumed event,
    Emitter<FeedState> emit,
  ) async {
    await Future.wait(
      state.feed.keys.map(
        (category) => _updateFeed(categoryId: category, emit: emit),
      ),
    );
  }

  Future<void> _updateFeed({
    required String categoryId,
    required Emitter<FeedState> emit,
  }) async {
    try {
      final categoryFeed = state.feed[categoryId] ?? [];
      final response = await _newsRepository.getFeed(
        categoryId: categoryId,
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
          feed: Map<String, List<NewsBlock>>.from(state.feed)
            ..addAll({categoryId: updatedCategoryFeed}),
          hasMoreNews: Map<String, bool>.from(state.hasMoreNews)
            ..addAll({categoryId: hasMoreNewsForCategory}),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FeedStatus.failure));
      addError(error, stackTrace);
    }
  }

  @override
  FeedState? fromJson(Map<String, dynamic> json) => FeedState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(FeedState state) => state.toJson();

  FutureOr<void> _onFeedRefreshRequested(
    FeedRefreshRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(status: FeedStatus.loading));

    try {
      final category = event.category;

      final response = await _newsRepository.getFeed(
        categoryId: category.id,
        offset: 0,
      );

      final refreshedCategoryFeed = response.feed;
      final hasMoreNewsForCategory =
          response.totalCount > refreshedCategoryFeed.length;

      emit(
        state.copyWith(
          status: FeedStatus.populated,
          feed: Map<String, List<NewsBlock>>.of(state.feed)
            ..addAll({category.id: refreshedCategoryFeed}),
          hasMoreNews: Map<String, bool>.of(state.hasMoreNews)
            ..addAll({category.id: hasMoreNewsForCategory}),
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FeedStatus.failure));
      addError(error, stackTrace);
    }
  }
}
