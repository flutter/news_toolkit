// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'block_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigateToArticleAction _$NavigateToArticleActionFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'NavigateToArticleAction',
      json,
      ($checkedConvert) {
        final val = NavigateToArticleAction(
          articleId: $checkedConvert('article_id', (v) => v as String),
          type: $checkedConvert('type',
              (v) => v as String? ?? NavigateToArticleAction.identifier),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {'articleId': 'article_id'},
    );

Map<String, dynamic> _$NavigateToArticleActionToJson(
    NavigateToArticleAction instance) {
  final val = <String, dynamic>{
    'article_id': instance.articleId,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uri', instance.uri?.toString());
  return val;
}

NavigateToFeedCategoryAction _$NavigateToFeedCategoryActionFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'NavigateToFeedCategoryAction',
      json,
      ($checkedConvert) {
        final val = NavigateToFeedCategoryAction(
          category: $checkedConvert(
              'category', (v) => $enumDecode(_$CategoryEnumMap, v)),
          type: $checkedConvert('type',
              (v) => v as String? ?? NavigateToFeedCategoryAction.identifier),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$NavigateToFeedCategoryActionToJson(
    NavigateToFeedCategoryAction instance) {
  final val = <String, dynamic>{
    'category': _$CategoryEnumMap[instance.category],
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uri', instance.uri?.toString());
  return val;
}

const _$CategoryEnumMap = {
  Category.business: 'business',
  Category.entertainment: 'entertainment',
  Category.top: 'top',
  Category.health: 'health',
  Category.science: 'science',
  Category.sports: 'sports',
  Category.technology: 'technology',
};

UnknownBlockAction _$UnknownBlockActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UnknownBlockAction',
      json,
      ($checkedConvert) {
        final val = UnknownBlockAction(
          type: $checkedConvert(
              'type', (v) => v as String? ?? UnknownBlockAction.identifier),
          uri: $checkedConvert(
              'uri', (v) => v == null ? null : Uri.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$UnknownBlockActionToJson(UnknownBlockAction instance) {
  final val = <String, dynamic>{
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uri', instance.uri?.toString());
  return val;
}
