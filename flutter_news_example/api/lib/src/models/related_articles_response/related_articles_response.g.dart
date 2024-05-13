// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_articles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedArticlesResponse _$RelatedArticlesResponseFromJson(
        Map<String, dynamic> json) =>
    RelatedArticlesResponse(
      relatedArticles:
          const NewsBlocksConverter().fromJson(json['relatedArticles'] as List),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$RelatedArticlesResponseToJson(
        RelatedArticlesResponse instance) =>
    <String, dynamic>{
      'relatedArticles':
          const NewsBlocksConverter().toJson(instance.relatedArticles),
      'totalCount': instance.totalCount,
    };
