// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article(
      title: json['title'] as String,
      blocks: const NewsBlocksConverter().fromJson(json['blocks'] as List),
      totalBlocks: (json['totalBlocks'] as num).toInt(),
      url: Uri.parse(json['url'] as String),
    );

Map<String, dynamic> _$ArticleToJson(Article instance) => <String, dynamic>{
      'title': instance.title,
      'blocks': const NewsBlocksConverter().toJson(instance.blocks),
      'totalBlocks': instance.totalBlocks,
      'url': instance.url.toString(),
    };
