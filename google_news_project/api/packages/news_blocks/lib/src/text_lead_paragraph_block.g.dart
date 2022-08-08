// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'text_lead_paragraph_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextLeadParagraphBlock _$TextLeadParagraphBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'TextLeadParagraphBlock',
      json,
      ($checkedConvert) {
        final val = TextLeadParagraphBlock(
          text: $checkedConvert('text', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? TextLeadParagraphBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$TextLeadParagraphBlockToJson(
        TextLeadParagraphBlock instance) =>
    <String, dynamic>{
      'text': instance.text,
      'type': instance.type,
    };
