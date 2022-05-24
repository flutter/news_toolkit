part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  populated,
  failure,
}

class SearchState extends Equatable {
  const SearchState({
    required this.articles,
    required this.topics,
    required this.status,
  });

  const SearchState.initial()
      : this(
          articles: const [],
          topics: const [],
          status: SearchStatus.initial,
        );

  final List<NewsBlock> articles;

  final List<String> topics;

  final SearchStatus status;

  @override
  List<Object?> get props => [articles, topics, status];

  SearchState copyWith({
    List<NewsBlock>? articles,
    List<String>? topics,
    SearchStatus? status,
  }) =>
      SearchState(
        articles: articles ?? this.articles,
        topics: topics ?? this.topics,
        status: status ?? this.status,
      );
}
