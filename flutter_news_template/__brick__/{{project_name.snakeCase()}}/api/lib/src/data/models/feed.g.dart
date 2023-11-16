// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => Feed(
      blocks: const NewsBlocksConverter().fromJson(json['blocks'] as List),
      totalBlocks: json['totalBlocks'] as int,
    );

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'blocks': const NewsBlocksConverter().toJson(instance.blocks),
      'totalBlocks': instance.totalBlocks,
    };
