// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'video_intro_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoIntroBlock _$VideoIntroBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'VideoIntroBlock',
      json,
      ($checkedConvert) {
        final val = VideoIntroBlock(
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$PostCategoryEnumMap, v)),
          title: $checkedConvert('title', (v) => v as String),
          videoUrl: $checkedConvert('video_url', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? VideoIntroBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'videoUrl': 'video_url'},
    );

Map<String, dynamic> _$VideoIntroBlockToJson(VideoIntroBlock instance) =>
    <String, dynamic>{
      'category': _$PostCategoryEnumMap[instance.category],
      'title': instance.title,
      'video_url': instance.videoUrl,
      'type': instance.type,
    };

const _$PostCategoryEnumMap = {
  PostCategory.business: 'business',
  PostCategory.entertainment: 'entertainment',
  PostCategory.health: 'health',
  PostCategory.science: 'science',
  PostCategory.sports: 'sports',
  PostCategory.technology: 'technology',
};
