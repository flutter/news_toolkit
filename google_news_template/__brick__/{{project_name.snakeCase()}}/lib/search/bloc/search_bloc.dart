import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const _duration = Duration(milliseconds: 300);

EventTransformer<Event> restartableDebounce<Event>(
  Duration duration, {
  required bool Function(Event) isDebounced,
}) {
  return (events, mapper) {
    final debouncedEvents = events.where(isDebounced).debounce(duration);
    final otherEvents = events.where((event) => !isDebounced(event));
    return otherEvents.merge(debouncedEvents).switchMap(mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const SearchState.initial()) {
    on<SearchTermChanged>(
      (event, emit) async {
        event.searchTerm.isEmpty
            ? await _onEmptySearchRequested(event, emit)
            : await _onSearchTermChanged(event, emit);
      },
      transformer: restartableDebounce(
        _duration,
        isDebounced: (event) => event.searchTerm.isNotEmpty,
      ),
    );
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onEmptySearchRequested(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.popular,
      ),
    );
    try {
      final popularSearch = await _newsRepository.popularSearch();
      emit(
        state.copyWith(
          articles: popularSearch.articles,
          topics: popularSearch.topics,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      state.copyWith(
        status: SearchStatus.loading,
        searchType: SearchType.relevant,
      ),
    );
    try {
      final relevantSearch = await _newsRepository.relevantSearch(
        term: event.searchTerm,
      );
      emit(
        state.copyWith(
          articles: relevantSearch.articles,
          topics: relevantSearch.topics,
          status: SearchStatus.populated,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: SearchStatus.failure));
      addError(error, stackTrace);
    }
  }
}
