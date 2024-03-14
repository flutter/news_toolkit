part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();
}

class FeedRequested extends FeedEvent {
  const FeedRequested({
    required this.category,
  });

  final Category category;

  @override
  List<Object> get props => [category];
}

class FeedRefreshRequested extends FeedEvent {
  const FeedRefreshRequested({required this.category});

  final Category category;

  @override
  List<Object> get props => [category];
}

class FeedResumed extends FeedEvent {
  const FeedResumed();

  @override
  List<Object> get props => [];
}
