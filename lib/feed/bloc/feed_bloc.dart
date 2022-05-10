import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/client.dart';
import 'package:news_repository/news_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required NewsRepository newsRepository,
  })  : _newsRepository = newsRepository,
        super(const FeedInitial()) {
    on<FetchFeed>(_onFetchFeed);
  }

  final NewsRepository _newsRepository;

  FutureOr<void> _onFetchFeed(FetchFeed event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    try {
      final feed = await _newsRepository.getFeed();
      emit(FeedPopulated(feed));
    } catch (error, stackTrace) {
      emit(const FeedError());
      addError(error, stackTrace);
    }
  }
}
