// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_caption_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextCaptionBlock _$TextCaptionBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TextCaptionBlock',
      json,
      ($checkedConvert) {
        final val = TextCaptionBlock(
          text: $checkedConvert('text', (v) => v as String),
          weight: $checkedConvert(
              'weight', (v) => $enumDecode(_$TextCaptionWeightEnumMap, v)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? TextCaptionBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$TextCaptionBlockToJson(TextCaptionBlock instance) =>
    <String, dynamic>{
      'weight': _$TextCaptionWeightEnumMap[instance.weight],
      'text': instance.text,
      'type': instance.type,
    };

const _$TextCaptionWeightEnumMap = {
  TextCaptionWeight.normal: 'normal',
  TextCaptionWeight.light: 'light',
};
