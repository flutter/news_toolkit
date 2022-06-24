// ignore: lines_longer_than_80_chars
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';

void main() {
  group('SubscriptionsState', () {
    test('initial has correct status', () {
      final initialState = SubscriptionsState.initial();

      expect(
        initialState,
        equals(
          SubscriptionsState(
            subscriptions: [],
            currentSubscription: SubscriptionPlan.none,
            purchaseStatus: PurchaseStatus.none,
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        SubscriptionsState.initial(),
        equals(
          SubscriptionsState.initial(),
        ),
      );
    });

    group('copyWith ', () {
      test(
          'returns same object '
          'when no parameters changed', () {
        expect(
          SubscriptionsState.initial().copyWith(),
          equals(SubscriptionsState.initial()),
        );
      });

      test(
          'returns object with updated currentSubscription '
          'when currentSubscription changed', () {
        expect(
          SubscriptionsState.initial()
              .copyWith(currentSubscription: SubscriptionPlan.premium),
          equals(
            SubscriptionsState(
              subscriptions: [],
              currentSubscription: SubscriptionPlan.premium,
              purchaseStatus: PurchaseStatus.none,
            ),
          ),
        );
      });
      test(
          'returns object with updated purchaseStatus '
          'when status changed', () {
        expect(
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.completed,
          ),
          equals(
            SubscriptionsState(
              subscriptions: [],
              currentSubscription: SubscriptionPlan.none,
              purchaseStatus: PurchaseStatus.completed,
            ),
          ),
        );
      });

      test(
          'returns object with updated selectedCategories '
          'when selectedCategories changed', () {
        expect(
          SubscriptionsState.initial().copyWith(
            subscriptions: [
              Subscription(
                benefits: [],
                cost: SubscriptionCost(
                  annual: 0,
                  monthly: 0,
                ),
                id: '1',
                name: SubscriptionPlan.none,
              ),
            ],
          ),
          equals(
            SubscriptionsState(
              subscriptions: [
                Subscription(
                  benefits: [],
                  cost: SubscriptionCost(
                    annual: 0,
                    monthly: 0,
                  ),
                  id: '1',
                  name: SubscriptionPlan.none,
                ),
              ],
              currentSubscription: SubscriptionPlan.none,
              purchaseStatus: PurchaseStatus.none,
            ),
          ),
        );
      });
    });
  });
}
