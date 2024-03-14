// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'slide_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlideBlock _$SlideBlockFromJson(Map<String, dynamic> json) => $checkedCreate(
      'SlideBlock',
      json,
      ($checkedConvert) {
        final val = SlideBlock(
          caption: $checkedConvert('caption', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          photoCredit: $checkedConvert('photo_credit', (v) => v as String),
          imageUrl: $checkedConvert('image_url', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? SlideBlock.identifier),
        );
        return val;
      },
      fieldKeyMap: const {
        'photoCredit': 'photo_credit',
        'imageUrl': 'image_url'
      },
    );

Map<String, dynamic> _$SlideBlockToJson(SlideBlock instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'description': instance.description,
      'photo_credit': instance.photoCredit,
      'image_url': instance.imageUrl,
      'type': instance.type,
    };
