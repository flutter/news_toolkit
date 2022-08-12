// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'article_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleResponse _$ArticleResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ArticleResponse',
      json,
      ($checkedConvert) {
        final val = ArticleResponse(
          title: $checkedConvert('title', (v) => v as String),
          content: $checkedConvert('content',
              (v) => const NewsBlocksConverter().fromJson(v as List)),
          totalCount: $checkedConvert('total_count', (v) => v as int),
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
          isPremium: $checkedConvert('is_premium', (v) => v as bool),
          isPreview: $checkedConvert('is_preview', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalCount': 'total_count',
        'isPremium': 'is_premium',
        'isPreview': 'is_preview'
      },
    );

Map<String, dynamic> _$ArticleResponseToJson(ArticleResponse instance) {
  final val = <String, dynamic>{
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('content', const NewsBlocksConverter().toJson(instance.content));
  val['total_count'] = instance.totalCount;
  val['url'] = instance.url.toString();
  val['is_premium'] = instance.isPremium;
  val['is_preview'] = instance.isPreview;
  return val;
}
