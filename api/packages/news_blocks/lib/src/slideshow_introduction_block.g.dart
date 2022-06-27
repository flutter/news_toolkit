// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'slideshow_introduction_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlideshowIntroductionBlock _$SlideshowIntroductionBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SlideshowIntroductionBlock',
      json,
      ($checkedConvert) {
        final val = SlideshowIntroductionBlock(
          title: $checkedConvert('title', (v) => v as String),
          coverImageUrl: $checkedConvert('cover_image_url', (v) => v as String),
          type: $checkedConvert('type',
              (v) => v as String? ?? SlideshowIntroductionBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'coverImageUrl': 'cover_image_url'},
    );

Map<String, dynamic> _$SlideshowIntroductionBlockToJson(
        SlideshowIntroductionBlock instance) =>
    <String, dynamic>{
      'title': instance.title,
      'cover_image_url': instance.coverImageUrl,
      'type': instance.type,
    };
