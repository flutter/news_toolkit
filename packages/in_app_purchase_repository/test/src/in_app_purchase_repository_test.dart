// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

void main() {
  group('InAppPurchaseRepository', () {
    late GoogleNewsTemplateApiClient apiClient;

    setUpAll(() {
      registerFallbackValue(SubscriptionPlan.none);
    });

    setUp(() {
      apiClient = MockGoogleNewsTemplateApiClient();
      when(
        () => apiClient.createSubscription(
          subscriptionId: any(named: 'subscriptionId'),
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

    group('requestSubscription', () {
      test('calls ApiClient.createSubscription', () async {
        final repository = InAppPurchaseRepository(apiClient: apiClient);
        await repository.requestSubscription('subscriptionId');
        verify(
          () => apiClient.createSubscription(subscriptionId: 'subscriptionId'),
        ).called(1);
      });

      test(
          'throws a RequestSubscriptionFailure '
          'when ApiClient.createSubscription fails', () async {
        when(
          () => apiClient.createSubscription(
            subscriptionId: any(named: 'subscriptionId'),
          ),
        ).thenThrow(Exception());

        expect(
          () => InAppPurchaseRepository(apiClient: apiClient)
              .requestSubscription('subscriptionId'),
          throwsA(isA<RequestSubscriptionFailure>()),
        );
      });
    });

    group('SubscriptionsFailure', () {
      final error = Exception('errorMessage');

      group('RequestSubscriptionFailure', () {
        test('has correct props', () {
          expect(RequestSubscriptionFailure(error).props, [error]);
        });
      });
    });
  });
}
