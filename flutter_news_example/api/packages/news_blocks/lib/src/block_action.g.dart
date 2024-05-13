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
        );
        return val;
      },
      fieldKeyMap: const {'articleId': 'article_id'},
    );

Map<String, dynamic> _$NavigateToArticleActionToJson(
        NavigateToArticleAction instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'type': instance.type,
    };

NavigateToVideoArticleAction _$NavigateToVideoArticleActionFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'NavigateToVideoArticleAction',
      json,
      ($checkedConvert) {
        final val = NavigateToVideoArticleAction(
          articleId: $checkedConvert('article_id', (v) => v as String),
          type: $checkedConvert('type',
              (v) => v as String? ?? NavigateToVideoArticleAction.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'articleId': 'article_id'},
    );

Map<String, dynamic> _$NavigateToVideoArticleActionToJson(
        NavigateToVideoArticleAction instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'type': instance.type,
    };

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
        );
        return val;
      },
    );

Map<String, dynamic> _$NavigateToFeedCategoryActionToJson(
        NavigateToFeedCategoryAction instance) =>
    <String, dynamic>{
      'category': _$CategoryEnumMap[instance.category]!,
      'type': instance.type,
    };

const _$CategoryEnumMap = {
  Category.business: 'business',
  Category.entertainment: 'entertainment',
  Category.top: 'top',
  Category.health: 'health',
  Category.science: 'science',
  Category.sports: 'sports',
  Category.technology: 'technology',
};

NavigateToSlideshowAction _$NavigateToSlideshowActionFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'NavigateToSlideshowAction',
      json,
      ($checkedConvert) {
        final val = NavigateToSlideshowAction(
          articleId: $checkedConvert('article_id', (v) => v as String),
          slideshow: $checkedConvert('slideshow',
              (v) => SlideshowBlock.fromJson(v as Map<String, dynamic>)),
          type: $checkedConvert('type',
              (v) => v as String? ?? NavigateToSlideshowAction.identifier),
        );
        return val;
      },
      fieldKeyMap: const {'articleId': 'article_id'},
    );

Map<String, dynamic> _$NavigateToSlideshowActionToJson(
        NavigateToSlideshowAction instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'slideshow': instance.slideshow.toJson(),
      'type': instance.type,
    };

UnknownBlockAction _$UnknownBlockActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UnknownBlockAction',
      json,
      ($checkedConvert) {
        final val = UnknownBlockAction(
          type: $checkedConvert(
              'type', (v) => v as String? ?? UnknownBlockAction.identifier),
        );
        return val;
      },
    );

Map<String, dynamic> _$UnknownBlockActionToJson(UnknownBlockAction instance) =>
    <String, dynamic>{
      'type': instance.type,
    };
