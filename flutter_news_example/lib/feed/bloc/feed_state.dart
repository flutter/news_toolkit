part of 'feed_bloc.dart';

enum FeedStatus {
  initial,
  loading,
  populated,
  failure,
}

@JsonSerializable()
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

  factory FeedState.fromJson(Map<String, dynamic> json) =>
      _$FeedStateFromJson(json);

  final FeedStatus status;
  final Map<String, List<NewsBlock>> feed;
  final Map<String, bool> hasMoreNews;

  @override
  List<Object> get props => [
        status,
        feed,
        hasMoreNews,
      ];

  FeedState copyWith({
    FeedStatus? status,
    Map<String, List<NewsBlock>>? feed,
    Map<String, bool>? hasMoreNews,
  }) {
    return FeedState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      hasMoreNews: hasMoreNews ?? this.hasMoreNews,
    );
  }

  Map<String, dynamic> toJson() => _$FeedStateToJson(this);
}
