// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'article_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleIntroductionBlock _$ArticleIntroductionBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'ArticleIntroductionBlock',
      json,
      ($checkedConvert) {
        final val = ArticleIntroductionBlock(
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$PostCategoryEnumMap, v)),
          author: $checkedConvert('author', (v) => v as String),
          publishedAt: $checkedConvert(
              'published_at', (v) => DateTime.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          type: $checkedConvert('type',
              (v) => v as String? ?? ArticleIntroductionBlock.identifier),
          imageUrl: $checkedConvert('image_url', (v) => v as String?),
          isPremium: $checkedConvert('is_premium', (v) => v as bool? ?? false),
        );
        return val;
      },
      fieldKeyMap: const {
        'publishedAt': 'published_at',
        'imageUrl': 'image_url',
        'isPremium': 'is_premium'
      },
    );

Map<String, dynamic> _$ArticleIntroductionBlockToJson(
    ArticleIntroductionBlock instance) {
  final val = <String, dynamic>{
    'category': _$PostCategoryEnumMap[instance.category]!,
    'author': instance.author,
    'published_at': instance.publishedAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('image_url', instance.imageUrl);
  val['title'] = instance.title;
  val['is_premium'] = instance.isPremium;
  val['type'] = instance.type;
  return val;
}

const _$PostCategoryEnumMap = {
  PostCategory.business: 'business',
  PostCategory.entertainment: 'entertainment',
  PostCategory.health: 'health',
  PostCategory.science: 'science',
  PostCategory.sports: 'sports',
  PostCategory.technology: 'technology',
};
