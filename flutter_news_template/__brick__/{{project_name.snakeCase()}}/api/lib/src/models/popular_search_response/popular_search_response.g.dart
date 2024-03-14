// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PopularSearchResponse _$PopularSearchResponseFromJson(
        Map<String, dynamic> json) =>
    PopularSearchResponse(
      articles: const NewsBlocksConverter().fromJson(json['articles'] as List),
      topics:
          (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PopularSearchResponseToJson(
        PopularSearchResponse instance) =>
    <String, dynamic>{
      'articles': const NewsBlocksConverter().toJson(instance.articles),
      'topics': instance.topics,
    };
