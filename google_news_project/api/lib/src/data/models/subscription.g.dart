// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, implicit_dynamic_parameter, lines_longer_than_80_chars, prefer_const_constructors, require_trailing_commas

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Subscription',
      json,
      ($checkedConvert) {
        final val = Subscription(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert(
              'name', (v) => $enumDecode(_$SubscriptionPlanEnumMap, v)),
          cost: $checkedConvert('cost',
              (v) => SubscriptionCost.fromJson(v as Map<String, dynamic>)),
          benefits: $checkedConvert('benefits',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': _$SubscriptionPlanEnumMap[instance.name],
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
    $checkedCreate(
      'SubscriptionCost',
      json,
      ($checkedConvert) {
        final val = SubscriptionCost(
          monthly: $checkedConvert('monthly', (v) => v as int),
          annual: $checkedConvert('annual', (v) => v as int),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionCostToJson(SubscriptionCost instance) =>
    <String, dynamic>{
      'monthly': instance.monthly,
      'annual': instance.annual,
    };
