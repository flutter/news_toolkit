// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionsResponse', () {
    test('can be (de)serialized', () {
      final subscriptionA = Subscription(
        id: 'a',
        name: SubscriptionPlan.plus,
        cost: SubscriptionCost(
          annual: 4200,
          monthly: 1200,
        ),
        benefits: const ['benefitA'],
      );
      final subscriptionB = Subscription(
        id: 'b',
        name: SubscriptionPlan.premium,
        cost: SubscriptionCost(
          annual: 5200,
          monthly: 2200,
        ),
        benefits: const ['benefitB'],
      );
      final response = SubscriptionsResponse(
        subscriptions: [subscriptionA, subscriptionB],
      );

      expect(
        SubscriptionsResponse.fromJson(response.toJson()),
        equals(response),
      );
    });
  });
}
