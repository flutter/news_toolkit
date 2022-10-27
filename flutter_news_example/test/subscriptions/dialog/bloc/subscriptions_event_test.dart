import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';

void main() {
  group('SubscriptionsEvent', () {
    group('SubscriptionsRequested', () {
      test('supports value comparisons', () {
        final event1 = SubscriptionsRequested();
        final event2 = SubscriptionsRequested();

        expect(event1, equals(event2));
      });
    });
    group('SubscriptionPurchaseRequested', () {
      test('supports value comparisons', () {
        final event1 = SubscriptionPurchaseRequested(
          subscription: const Subscription(
            benefits: [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );
        final event2 = SubscriptionPurchaseRequested(
          subscription: const Subscription(
            benefits: [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );

        expect(event1, equals(event2));
      });
    });

    group('SubscriptionPurchaseCompleted', () {
      test('supports value comparisons', () {
        final event1 = SubscriptionPurchaseCompleted(
          subscription: const Subscription(
            benefits: [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );
        final event2 = SubscriptionPurchaseCompleted(
          subscription: const Subscription(
            benefits: [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );

        expect(event1, equals(event2));
      });
    });

    group('SubscriptionPurchaseUpdated', () {
      test('supports value comparisons', () {
        final event1 = SubscriptionPurchaseUpdated(
          purchase: const PurchaseCanceled(),
        );
        final event2 = SubscriptionPurchaseUpdated(
          purchase: const PurchaseCanceled(),
        );

        expect(event1, equals(event2));
      });
    });
  });
}
