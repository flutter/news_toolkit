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
  });

  const ArticleState.initial()
      : this(
          status: ArticleStatus.initial,
        );

  final ArticleStatus status;
  final List<NewsBlock> content;
  final bool hasMoreContent;

  @override
  List<Object> get props => [
        status,
        content,
        hasMoreContent,
      ];

  ArticleState copyWith({
    ArticleStatus? status,
    List<NewsBlock>? content,
    bool? hasMoreContent,
  }) {
    return ArticleState(
      status: status ?? this.status,
      content: content ?? this.content,
      hasMoreContent: hasMoreContent ?? this.hasMoreContent,
    );
  }
}
