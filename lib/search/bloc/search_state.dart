part of 'search_bloc.dart';

enum SearchStatus {
  initial,
  loading,
  populated,
  failure,
}

class SearchState extends Equatable {
  const SearchState({
    required this.keyword,
    required this.articles,
    required this.topics,
    required this.status,
  });

  const SearchState.initial()
      : this(
          keyword: '',
          articles: const [],
          topics: const [],
          status: SearchStatus.initial,
        );

  final String keyword;

  final List<NewsBlock> articles;

  final List<String> topics;

  final SearchStatus status;

  @override
  List<Object?> get props => [keyword, articles, topics, status];

  SearchState copyWith({
    String? keyword,
    List<NewsBlock>? articles,
    List<String>? topics,
    SearchStatus? status,
  }) =>
      SearchState(
        keyword: keyword ?? this.keyword,
        articles: articles ?? this.articles,
        topics: topics ?? this.topics,
        status: status ?? this.status,
      );
}
