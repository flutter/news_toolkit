part of 'feed_bloc.dart';

enum FeedStatus {
  initial,
  loading,
  populated,
  failure,
}

class FeedState extends Equatable {
  const FeedState({
    required this.status,
    this.feed = const {},
    this.hasMoreNews = const {},
  });

  const FeedState.initial()
      : this(
          status: FeedStatus.initial,
        );

  final FeedStatus status;
  final Map<Category, List<NewsBlock>> feed;
  final Map<Category, bool> hasMoreNews;

  @override
  List<Object> get props => [
        status,
        feed,
        hasMoreNews,
      ];

  FeedState copyWith({
    FeedStatus? status,
    Map<Category, List<NewsBlock>>? feed,
    Map<Category, bool>? hasMoreNews,
  }) {
    return FeedState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      hasMoreNews: hasMoreNews ?? this.hasMoreNews,
    );
  }
}
