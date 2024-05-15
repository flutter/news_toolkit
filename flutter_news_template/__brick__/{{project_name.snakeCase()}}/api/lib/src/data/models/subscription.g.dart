// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as String,
      name: $enumDecode(_$SubscriptionPlanEnumMap, json['name']),
      cost: SubscriptionCost.fromJson(json['cost'] as Map<String, dynamic>),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': _$SubscriptionPlanEnumMap[instance.name]!,
      'cost': instance.cost.toJson(),
      'benefits': instance.benefits,
    };

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.none: 'none',
  SubscriptionPlan.basic: 'basic',
  SubscriptionPlan.plus: 'plus',
  SubscriptionPlan.premium: 'premium',
};

SubscriptionCost _$SubscriptionCostFromJson(Map<String, dynamic> json) =>
    SubscriptionCost(
      monthly: (json['monthly'] as num).toInt(),
      annual: (json['annual'] as num).toInt(),
    );

Map<String, dynamic> _$SubscriptionCostToJson(SubscriptionCost instance) =>
    <String, dynamic>{
      'monthly': instance.monthly,
      'annual': instance.annual,
    };
