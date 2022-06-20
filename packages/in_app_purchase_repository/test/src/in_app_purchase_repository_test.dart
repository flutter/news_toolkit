// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:google_news_template_api/client.dart' hide User;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockInAppPurchase extends Mock implements InAppPurchase {}

void main() {
  group('InAppPurchaseRepository', () {
    late AuthenticationClient authenticationClient;
    late GoogleNewsTemplateApiClient apiClient;
    late InAppPurchase inAppPurchase;

    final product = ProductDetails(
      id: 'dd339fda-33e9-49d0-9eb5-0ccb77eb760f',
      title: 'premium',
      description: 'premium subscription',
      price: r'$14.99',
      rawPrice: 14.99,
      currencyCode: 'USD',
    );

    final user = User(
      id: '123',
      name: 'name',
    );

    setUpAll(() {
      registerFallbackValue(SubscriptionPlan.none);
    });

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      apiClient = MockGoogleNewsTemplateApiClient();
      inAppPurchase = MockInAppPurchase();

      when(
        () => apiClient.createSubscription(
          subscription: any(named: 'subscription'),
        ),
      ).thenAnswer((_) async {});

      when(() => authenticationClient.user).thenAnswer(
        (invocation) => Stream.fromIterable([user]),
      );
    });

    test('can be instantiated', () {
      expect(
        InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        ),
        isNotNull,
      );
    });

    test('currentSubscriptionPlan emits none when initialized', () {
      expectLater(
        InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        ).currentSubscriptionPlan,
        emits(SubscriptionPlan.none),
      );
    });

    group('purchase', () {
      test('calls inAppPurchase.buyNonConsumable', () async {
        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );
        when(() => inAppPurchase.queryProductDetails).thenReturn(
          (invocation) async => ProductDetailsResponse(
            productDetails: [product],
            notFoundIDs: [],
          ),
        );

        await repository.purchase(product: product);

        verify(
          () => inAppPurchase.buyNonConsumable(
              purchaseParam: PurchaseParam(
                  productDetails: product, applicationUserName: user.name)),
        ).called(1);
      });
    });
  });
}

    //   test('adds plan to currentSubscriptionPlan stream', () async {
    //     final repository = InAppPurchaseRepository(
    //       authenticationClient: authenticationClient,
    //       apiClient: apiClient,
    //       inAppPurchase: inAppPurchase,
    //     );

    //     await expectLater(
    //       repository.currentSubscriptionPlan,
    //       emitsInOrder(<SubscriptionPlan>[
    //         SubscriptionPlan.none,
    //         SubscriptionPlan.premium,
    //       ]),
    //     );

    //     await repository.purchase(product: product);
    //   });

    //   test(
    //       'throws a RequestSubscriptionPlanFailure '
    //       'when ApiClient.createSubscription fails', () async {
    //     when(
    //       () => apiClient.createSubscription(
    //         subscription: any(named: 'subscription'),
    //       ),
    //     ).thenThrow(Exception());

    //     expect(
    //       () => InAppPurchaseRepository(
    //         authenticationClient: authenticationClient,
    //         apiClient: apiClient,
    //         inAppPurchase: inAppPurchase,
    //       ).requestSubscriptionPlan(SubscriptionPlan.premium),
    //       throwsA(isA<RequestSubscriptionPlanFailure>()),
    //     );
    //   });
    // });

    // group('SubscriptionsFailure', () {
    //   final error = Exception('errorMessage');

    //   group('RequestSubscriptionPlanFailure', () {
    //     test('has correct props', () {
    //       expect(RequestSubscriptionPlanFailure(error).props, [error]);
    //     });
    //   });
    // });
  