// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'related_articles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatedArticles _$RelatedArticlesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RelatedArticles',
      json,
      ($checkedConvert) {
        final val = RelatedArticles(
          blocks: $checkedConvert(
              'blocks', (v) => const NewsBlocksConverter().fromJson(v as List)),
          totalBlocks: $checkedConvert('total_blocks', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'totalBlocks': 'total_blocks'},
    );

Map<String, dynamic> _$RelatedArticlesToJson(RelatedArticles instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('blocks', const NewsBlocksConverter().toJson(instance.blocks));
  val['total_blocks'] = instance.totalBlocks;
  return val;
}
