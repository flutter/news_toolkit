part of 'article_bloc.dart';

enum ArticleStatus {
  initial,
  loading,
  populated,
  failure,
  shareFailure,
  rewardedAdWatchedFailure,
}

class ArticleState extends Equatable {
  const ArticleState({
    required this.status,
    this.title,
    this.content = const [],
    this.relatedArticles = const [],
    this.hasMoreContent = true,
    this.uri,
    this.hasReachedArticleViewsLimit = false,
    this.isPreview = false,
    this.isPremium = false,
  });

  const ArticleState.initial()
      : this(
          status: ArticleStatus.initial,
        );

  final ArticleStatus status;
  final String? title;
  final List<NewsBlock> content;
  final List<NewsBlock> relatedArticles;
  final bool hasMoreContent;
  final Uri? uri;
  final bool hasReachedArticleViewsLimit;
  final bool isPreview;
  final bool isPremium;

  @override
  List<Object?> get props => [
        status,
        title,
        content,
        relatedArticles,
        hasMoreContent,
        uri,
        hasReachedArticleViewsLimit,
        isPreview,
        isPremium,
      ];

  ArticleState copyWith({
    ArticleStatus? status,
    String? title,
    List<NewsBlock>? content,
    List<NewsBlock>? relatedArticles,
    bool? hasMoreContent,
    Uri? uri,
    bool? hasReachedArticleViewsLimit,
    bool? isPreview,
    bool? isPremium,
  }) {
    return ArticleState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      relatedArticles: relatedArticles ?? this.relatedArticles,
      hasMoreContent: hasMoreContent ?? this.hasMoreContent,
      uri: uri ?? this.uri,
      hasReachedArticleViewsLimit:
          hasReachedArticleViewsLimit ?? this.hasReachedArticleViewsLimit,
      isPreview: isPreview ?? this.isPreview,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
