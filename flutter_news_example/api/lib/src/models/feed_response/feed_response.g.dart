// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedResponse _$FeedResponseFromJson(Map<String, dynamic> json) => FeedResponse(
      feed: const NewsBlocksConverter().fromJson(json['feed'] as List),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$FeedResponseToJson(FeedResponse instance) =>
    <String, dynamic>{
      'feed': const NewsBlocksConverter().toJson(instance.feed),
      'totalCount': instance.totalCount,
    };
