// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relevant_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelevantSearchResponse _$RelevantSearchResponseFromJson(
        Map<String, dynamic> json) =>
    RelevantSearchResponse(
      articles: const NewsBlocksConverter().fromJson(json['articles'] as List),
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RelevantSearchResponseToJson(
        RelevantSearchResponse instance) =>
    <String, dynamic>{
      'articles': const NewsBlocksConverter().toJson(instance.articles),
      'topics': instance.topics,
    };
