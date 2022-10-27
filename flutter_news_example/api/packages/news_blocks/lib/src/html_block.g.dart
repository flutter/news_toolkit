// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'html_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HtmlBlock _$HtmlBlockFromJson(Map<String, dynamic> json) => $checkedCreate(
      'HtmlBlock',
      json,
      ($checkedConvert) {
        final val = HtmlBlock(
          content: $checkedConvert('content', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => v as String? ?? HtmlBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$HtmlBlockToJson(HtmlBlock instance) => <String, dynamic>{
      'content': instance.content,
      'type': instance.type,
    };
