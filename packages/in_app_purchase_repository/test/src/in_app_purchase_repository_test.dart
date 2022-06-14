// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

void main() {
  group('InApPurchaseRepository', () {
    late GoogleNewsTemplateApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(SubscriptionPlan.none);
    });

    setUp(() {
      apiClient = MockGoogleNewsTemplateApiClient();
      when(
        () => apiClient.createSubscription(
          subscription: any(named: 'subscription'),
        ),
      ).thenAnswer((_) async {});
    });

    test('can be instantiated', () {
      expect(
        InAppPurchaseRepository(apiClient: apiClient),
        isNotNull,
      );
    });

    test('currentSubscriptionPlan emits none when initialized', () {
      expectLater(
        InAppPurchaseRepository(apiClient: apiClient).currentSubscriptionPlan,
        emits(SubscriptionPlan.none),
      );
    });

    group('requestSubscriptionPlan', () {
      test('calls ApiClient.createSubscription', () async {
        final repository = InAppPurchaseRepository(apiClient: apiClient);
        await repository.requestSubscriptionPlan(SubscriptionPlan.premium);
        verify(
          () => apiClient.createSubscription(
            subscription: SubscriptionPlan.premium,
          ),
        ).called(1);
      });

      test('adds plan to currentSubscriptionPlan stream', () {
        final repository = InAppPurchaseRepository(apiClient: apiClient);

        expectLater(
          repository.currentSubscriptionPlan,
          emitsInOrder(<SubscriptionPlan>[
            SubscriptionPlan.none,
            SubscriptionPlan.premium,
          ]),
        );

        repository.requestSubscriptionPlan(SubscriptionPlan.premium);
      });

      test(
          'throws a RequestSubscriptionPlanFailure '
          'when ApiClient.createSubscription fails', () async {
        when(
          () => apiClient.createSubscription(
            subscription: any(named: 'subscription'),
          ),
        ).thenThrow(Exception());

        expect(
          () => InAppPurchaseRepository(apiClient: apiClient)
              .requestSubscriptionPlan(SubscriptionPlan.premium),
          throwsA(isA<RequestSubscriptionPlanFailure>()),
        );
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
