// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscriptions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionsResponse _$SubscriptionsResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionsResponse(
      subscriptions: (json['subscriptions'] as List<dynamic>)
          .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubscriptionsResponseToJson(
        SubscriptionsResponse instance) =>
    <String, dynamic>{
      'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
    };
