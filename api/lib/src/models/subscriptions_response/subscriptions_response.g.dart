// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'subscriptions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionsResponse _$SubscriptionsResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionsResponse',
      json,
      ($checkedConvert) {
        final val = SubscriptionsResponse(
          subscriptions: $checkedConvert(
              'subscriptions',
              (v) => (v as List<dynamic>)
                  .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionsResponseToJson(
        SubscriptionsResponse instance) =>
    <String, dynamic>{
      'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
    };
