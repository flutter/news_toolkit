// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'video_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoIntroductionBlock _$VideoIntroductionBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'VideoIntroductionBlock',
      json,
      ($checkedConvert) {
        final val = VideoIntroductionBlock(
          categoryId: $checkedConvert('category_id', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          videoUrl: $checkedConvert('video_url', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? VideoIntroductionBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'categoryId': 'category_id', 'videoUrl': 'video_url'},
    );

Map<String, dynamic> _$VideoIntroductionBlockToJson(
        VideoIntroductionBlock instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'title': instance.title,
      'video_url': instance.videoUrl,
      'type': instance.type,
    };
