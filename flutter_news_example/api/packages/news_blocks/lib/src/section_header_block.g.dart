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
              (v) => const BlockActionConverter()
                  .fromJson(v as Map<String, dynamic>?)),
          type: $checkedConvert(
              'type', (v) => v as String? ?? SectionHeaderBlock.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$SectionHeaderBlockToJson(SectionHeaderBlock instance) {
  final val = <String, dynamic>{
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('action', const BlockActionConverter().toJson(instance.action));
  val['type'] = instance.type;
  return val;
}
