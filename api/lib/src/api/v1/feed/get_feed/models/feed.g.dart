// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feed _$FeedFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Feed',
      json,
      ($checkedConvert) {
        final val = Feed(
          blocks: $checkedConvert(
              'blocks',
              (v) => const _NewsBlocksConverter()
                  .fromJson(v as List<Map<String, dynamic>>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$FeedToJson(Feed instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('blocks', const _NewsBlocksConverter().toJson(instance.blocks));
  return val;
}
