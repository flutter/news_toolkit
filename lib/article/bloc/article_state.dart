part of 'article_bloc.dart';

enum ArticleStatus {
  initial,
  loading,
  populated,
  failure,
}

class ArticleState extends Equatable {
  const ArticleState({
    required this.status,
    this.content = const [],
    this.hasMoreContent = true,
    this.hasReachedArticleViewsLimit = false,
  });

  const ArticleState.initial()
      : this(
          status: ArticleStatus.initial,
        );

  final ArticleStatus status;
  final List<NewsBlock> content;
  final bool hasMoreContent;
  final bool hasReachedArticleViewsLimit;

  @override
  List<Object> get props => [
        status,
        content,
        hasMoreContent,
        hasReachedArticleViewsLimit,
      ];

  ArticleState copyWith({
    ArticleStatus? status,
    List<NewsBlock>? content,
    bool? hasMoreContent,
    bool? hasReachedArticleViewsLimit,
  }) {
    return ArticleState(
      status: status ?? this.status,
      content: content ?? this.content,
      hasMoreContent: hasMoreContent ?? this.hasMoreContent,
      hasReachedArticleViewsLimit:
          hasReachedArticleViewsLimit ?? this.hasReachedArticleViewsLimit,
    );
  }
}
