part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  populated,
  failure,
}

enum SearchDisplayMode {
  popular,
  relevant,
}

class SearchState extends Equatable {
  const SearchState({
    required this.articles,
    required this.topics,
    required this.status,
    required this.displayMode,
  });

  const SearchState.initial()
      : this(
          articles: const [],
          topics: const [],
          status: SearchStatus.initial,
          displayMode: SearchDisplayMode.popular,
        );

  final List<NewsBlock> articles;

  final List<String> topics;

  final SearchStatus status;

  final SearchDisplayMode displayMode;

  @override
  List<Object?> get props => [articles, topics, status, displayMode];

  SearchState copyWith({
    List<NewsBlock>? articles,
    List<String>? topics,
    SearchStatus? status,
    SearchDisplayMode? displayMode,
  }) =>
      SearchState(
        articles: articles ?? this.articles,
        topics: topics ?? this.topics,
        status: status ?? this.status,
        displayMode: displayMode ?? this.displayMode,
      );
}
