// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'section_header_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionHeaderBlock _$SectionHeaderBlockFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SectionHeaderBlock',
      json,
      ($checkedConvert) {
        final val = SectionHeaderBlock(
          title: $checkedConvert('title', (v) => v as String),
          action: $checkedConvert(
              'action',
              (v) => v == null
                  ? null
                  : BlockAction.fromJson(v as Map<String, dynamic>)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? sectionHeaderBlockType),
        );
        return val;
      },
    );

Map<String, dynamic> _$SectionHeaderBlockToJson(SectionHeaderBlock instance) =>
    <String, dynamic>{
      'title': instance.title,
      'action': instance.action?.toJson(),
      'type': instance.type,
    };
