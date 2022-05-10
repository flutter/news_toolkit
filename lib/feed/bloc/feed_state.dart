part of 'feed_bloc.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedPopulated extends FeedState {
  const FeedPopulated(this.feed) : super();

  final FeedResponse feed;

  @override
  List<Object> get props => [Feed];
}

class FeedError extends FeedState {
  const FeedError();
}
