part of 'article_bloc.dart';

enum ArticleStatus {
  initial,
  loading,
  populated,
  failure,
  shareFailure,
  rewardedAdWatchedFailure,
}

@JsonSerializable()
class ArticleState extends Equatable {
  const ArticleState({
    required this.status,
    this.title,
    this.content = const [],
    this.contentTotalCount,
    this.contentSeenCount = 0,
    this.relatedArticles = const [],
    this.hasMoreContent = true,
    this.uri,
    this.hasReachedArticleViewsLimit = false,
    this.isPreview = false,
    this.isPremium = false,
    this.showInterstitialAd = false,
  });

  factory ArticleState.fromJson(Map<String, dynamic> json) =>
      _$ArticleStateFromJson(json);

  const ArticleState.initial()
      : this(
          status: ArticleStatus.initial,
        );

  final ArticleStatus status;
  final String? title;
  final List<NewsBlock> content;
  final int? contentTotalCount;
  final int contentSeenCount;
  final List<NewsBlock> relatedArticles;
  final bool hasMoreContent;
  final Uri? uri;
  final bool hasReachedArticleViewsLimit;
  final bool isPreview;
  final bool isPremium;
  final bool showInterstitialAd;

  int get contentMilestone => contentTotalCount != null && !isPreview
      ? _getContentMilestoneForPercentage(contentSeenCount / contentTotalCount!)
      : 0;

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
        contentTotalCount,
        contentSeenCount,
        showInterstitialAd,
      ];

  ArticleState copyWith({
    ArticleStatus? status,
    String? title,
    List<NewsBlock>? content,
    int? contentTotalCount,
    int? contentSeenCount,
    List<NewsBlock>? relatedArticles,
    bool? hasMoreContent,
    Uri? uri,
    bool? hasReachedArticleViewsLimit,
    bool? isPreview,
    bool? isPremium,
    bool? showInterstitialAd,
  }) {
    return ArticleState(
      status: status ?? this.status,
      title: title ?? this.title,
      content: content ?? this.content,
      contentTotalCount: contentTotalCount ?? this.contentTotalCount,
      contentSeenCount: contentSeenCount ?? this.contentSeenCount,
      relatedArticles: relatedArticles ?? this.relatedArticles,
      hasMoreContent: hasMoreContent ?? this.hasMoreContent,
      uri: uri ?? this.uri,
      hasReachedArticleViewsLimit:
          hasReachedArticleViewsLimit ?? this.hasReachedArticleViewsLimit,
      isPreview: isPreview ?? this.isPreview,
      isPremium: isPremium ?? this.isPremium,
      showInterstitialAd: showInterstitialAd ?? this.showInterstitialAd,
    );
  }

  Map<String, dynamic> toJson() => _$ArticleStateToJson(this);
}

int _getContentMilestoneForPercentage(double percentage) {
  if (percentage == 1.0) {
    return 100;
  } else if (percentage >= 0.75) {
    return 75;
  } else if (percentage >= 0.5) {
    return 50;
  } else if (percentage >= 0.25) {
    return 25;
  } else {
    return 0;
  }
}
