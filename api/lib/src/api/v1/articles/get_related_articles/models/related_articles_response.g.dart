// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'related_articles_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedArticlesResponse _$RelatedArticlesResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RelatedArticlesResponse',
      json,
      ($checkedConvert) {
        final val = RelatedArticlesResponse(
          relatedArticles: $checkedConvert('related_articles',
              (v) => const NewsBlocksConverter().fromJson(v as List)),
          totalCount: $checkedConvert('total_count', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {
        'relatedArticles': 'related_articles',
        'totalCount': 'total_count'
      },
    );

Map<String, dynamic> _$RelatedArticlesResponseToJson(
    RelatedArticlesResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('related_articles',
      const NewsBlocksConverter().toJson(instance.relatedArticles));
  val['total_count'] = instance.totalCount;
  return val;
}
