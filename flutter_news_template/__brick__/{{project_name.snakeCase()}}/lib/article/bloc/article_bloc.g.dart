// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleState _$ArticleStateFromJson(Map<String, dynamic> json) => ArticleState(
      status: $enumDecode(_$ArticleStatusEnumMap, json['status']),
      title: json['title'] as String?,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      contentTotalCount: (json['contentTotalCount'] as num?)?.toInt(),
      contentSeenCount: (json['contentSeenCount'] as num?)?.toInt() ?? 0,
      relatedArticles: (json['relatedArticles'] as List<dynamic>?)
              ?.map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasMoreContent: json['hasMoreContent'] as bool? ?? true,
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      hasReachedArticleViewsLimit:
          json['hasReachedArticleViewsLimit'] as bool? ?? false,
      isPreview: json['isPreview'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      showInterstitialAd: json['showInterstitialAd'] as bool? ?? false,
    );

Map<String, dynamic> _$ArticleStateToJson(ArticleState instance) =>
    <String, dynamic>{
      'status': _$ArticleStatusEnumMap[instance.status]!,
      'title': instance.title,
      'content': instance.content.map((e) => e.toJson()).toList(),
      'contentTotalCount': instance.contentTotalCount,
      'contentSeenCount': instance.contentSeenCount,
      'relatedArticles':
          instance.relatedArticles.map((e) => e.toJson()).toList(),
      'hasMoreContent': instance.hasMoreContent,
      'uri': instance.uri?.toString(),
      'hasReachedArticleViewsLimit': instance.hasReachedArticleViewsLimit,
      'isPreview': instance.isPreview,
      'isPremium': instance.isPremium,
      'showInterstitialAd': instance.showInterstitialAd,
    };

const _$ArticleStatusEnumMap = {
  ArticleStatus.initial: 'initial',
  ArticleStatus.loading: 'loading',
  ArticleStatus.populated: 'populated',
  ArticleStatus.failure: 'failure',
  ArticleStatus.shareFailure: 'shareFailure',
  ArticleStatus.rewardedAdWatchedFailure: 'rewardedAdWatchedFailure',
};
