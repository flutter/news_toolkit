// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedState _$FeedStateFromJson(Map<String, dynamic> json) => FeedState(
      status: $enumDecode(_$FeedStatusEnumMap, json['status']),
      feed: (json['feed'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k,
                (e as List<dynamic>)
                    .map((e) => NewsBlock.fromJson(e as Map<String, dynamic>))
                    .toList()),
          ) ??
          const {},
      hasMoreNews: (json['hasMoreNews'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
    );

Map<String, dynamic> _$FeedStateToJson(FeedState instance) => <String, dynamic>{
      'status': _$FeedStatusEnumMap[instance.status]!,
      'feed': instance.feed
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
      'hasMoreNews': instance.hasMoreNews,
    };

const _$FeedStatusEnumMap = {
  FeedStatus.initial: 'initial',
  FeedStatus.loading: 'loading',
  FeedStatus.populated: 'populated',
  FeedStatus.failure: 'failure',
};
