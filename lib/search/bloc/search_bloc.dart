import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

EventTransformer<E> debounce<E>() {
  return (events, mapper) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(mapper);
  };
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const SearchState.initial()) {
    on<PopularSearchRequested>(_onLoadPopular);
    on<SearchTermChanged>(
      _onKeywordChanged,
      transformer: debounce(),
    );
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onLoadPopular(
    PopularSearchRequested event,
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

  FutureOr<void> _onKeywordChanged(
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
