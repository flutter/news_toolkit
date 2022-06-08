// ignore_for_file: prefer_const_constructors

import 'package:subscriptions_repository/subscriptions_repository.dart';
import 'package:test/test.dart';

void main() {
  group('SubscriptionsRepository', () {
    test('can be instantiated', () {
      expect(SubscriptionsRepository(), isNotNull);
    });

    test('currentSubscriptionPlan emits none when initialized', () {
      expectLater(
        SubscriptionsRepository().currentSubscriptionPlan,
        emits(SubscriptionPlan.none),
      );
    });

    group('requestSubscriptionPlan', () {
      test('adds plan to currentSubscriptionPlan stream', () {
        final repository = SubscriptionsRepository();

        expectLater(
          repository.currentSubscriptionPlan,
          emitsInOrder(<SubscriptionPlan>[
            SubscriptionPlan.none,
            SubscriptionPlan.premium,
          ]),
        );

        repository.requestSubscriptionPlan(SubscriptionPlan.premium);
      });
    });

    group('SubscriptionsFailure', () {
      final error = Exception('errorMessage');

      group('RequestSubscriptionPlanFailure', () {
        test('has correct props', () {
          expect(RequestSubscriptionPlanFailure(error).props, [error]);
        });
      });
    });
  });
}
