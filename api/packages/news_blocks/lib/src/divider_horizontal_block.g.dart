// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'divider_horizontal_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DividerHorizontalBlock _$DividerHorizontalBlockFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'DividerHorizontalBlock',
      json,
      ($checkedConvert) {
        final val = DividerHorizontalBlock(
          type: $checkedConvert(
              'type', (v) => v as String? ?? DividerHorizontalBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$DividerHorizontalBlockToJson(
        DividerHorizontalBlock instance) =>
    <String, dynamic>{
      'type': instance.type,
    };
