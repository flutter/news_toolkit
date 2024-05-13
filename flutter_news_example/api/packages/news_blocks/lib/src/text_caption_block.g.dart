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
          color: $checkedConvert(
              'color', (v) => $enumDecode(_$TextCaptionColorEnumMap, v)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? TextCaptionBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$TextCaptionBlockToJson(TextCaptionBlock instance) =>
    <String, dynamic>{
      'color': _$TextCaptionColorEnumMap[instance.color]!,
      'text': instance.text,
      'type': instance.type,
    };

const _$TextCaptionColorEnumMap = {
  TextCaptionColor.normal: 'normal',
  TextCaptionColor.light: 'light',
};
