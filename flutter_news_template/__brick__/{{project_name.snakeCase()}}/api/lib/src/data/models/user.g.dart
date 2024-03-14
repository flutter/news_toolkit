// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      subscription:
          $enumDecode(_$SubscriptionPlanEnumMap, json['subscription']),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'subscription': _$SubscriptionPlanEnumMap[instance.subscription]!,
    };

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.none: 'none',
  SubscriptionPlan.basic: 'basic',
  SubscriptionPlan.plus: 'plus',
  SubscriptionPlan.premium: 'premium',
};
