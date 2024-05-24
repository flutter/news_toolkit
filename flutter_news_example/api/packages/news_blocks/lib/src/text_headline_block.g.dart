// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_headline_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextHeadlineBlock _$TextHeadlineBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TextHeadlineBlock',
      json,
      ($checkedConvert) {
        final val = TextHeadlineBlock(
          text: $checkedConvert('text', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? TextHeadlineBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$TextHeadlineBlockToJson(TextHeadlineBlock instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': instance.type,
    };
