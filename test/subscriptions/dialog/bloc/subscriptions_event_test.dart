import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
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

    group('CurrentSubscriptionChanged', () {
      test('supports value comparisons', () {
        final event1 = CurrentSubscriptionChanged(
          subscription: SubscriptionPlan.none,
        );
        final event2 = CurrentSubscriptionChanged(
          subscription: SubscriptionPlan.none,
        );

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

    group('InAppPurchaseUpdated', () {
      test('supports value comparisons', () {
        final event1 = InAppPurchaseUpdated(
          purchase: const PurchaseCanceled(),
        );
        final event2 = InAppPurchaseUpdated(
          purchase: const PurchaseCanceled(),
        );

        expect(event1, equals(event2));
      });
    });
  });
}
