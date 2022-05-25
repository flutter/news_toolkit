// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'relevant_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelevantSearchResponse _$RelevantSearchResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RelevantSearchResponse',
      json,
      ($checkedConvert) {
        final val = RelevantSearchResponse(
          articles: $checkedConvert('articles',
              (v) => const NewsBlocksConverter().fromJson(v as List)),
          topics: $checkedConvert('topics',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$RelevantSearchResponseToJson(
    RelevantSearchResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(
      'articles', const NewsBlocksConverter().toJson(instance.articles));
  val['topics'] = instance.topics;
  return val;
}
