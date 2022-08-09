// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'video_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoBlock _$VideoBlockFromJson(Map<String, dynamic> json) => $checkedCreate(
      'VideoBlock',
      json,
      ($checkedConvert) {
        final val = VideoBlock(
          videoUrl: $checkedConvert('video_url', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? VideoBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'videoUrl': 'video_url'},
    );

Map<String, dynamic> _$VideoBlockToJson(VideoBlock instance) =>
    <String, dynamic>{
      'video_url': instance.videoUrl,
      'type': instance.type,
    };
