// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:flutter_news_template_api/client.dart' hide User;
import 'package:flutter_news_template_api/client.dart' as api;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockInAppPurchase extends Mock implements InAppPurchase {}

class FakePurchaseDetails extends Fake implements PurchaseDetails {}

class InAppPurchaseException extends InAppPurchaseFailure {
  InAppPurchaseException(super.error);
}

void main() {
  test('InAppPurchaseFailure supports value comparisons', () {
    expect(
      InAppPurchaseException('error'),
      equals(
        InAppPurchaseException('error'),
      ),
    );
  });

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

    final user = AuthenticationUser(
      id: '123',
      name: 'name',
    );

    final subscription = Subscription(
      id: product.id,
      name: SubscriptionPlan.none,
      cost: SubscriptionCost(annual: 1, monthly: 2),
      benefits: const ['benefit', 'nextBenefit'],
    );

    final apiUserResponse = CurrentUserResponse(
      user: api.User(
        id: user.id,
        subscription: subscription.name,
      ),
    );

    setUpAll(() {
      registerFallbackValue(SubscriptionPlan.none);
      registerFallbackValue(
        PurchaseParam(
          productDetails: product,
          applicationUserName: user.name,
        ),
      );
      registerFallbackValue(FakePurchaseDetails());
    });

    setUp(() {
      authenticationClient = MockAuthenticationClient();
      apiClient = MockGoogleNewsTemplateApiClient();
      inAppPurchase = MockInAppPurchase();

      when(
        () => apiClient.createSubscription(
          subscriptionId: any(named: 'subscriptionId'),
        ),
      ).thenAnswer((_) async {});

      when(
        apiClient.getCurrentUser,
      ).thenAnswer((_) async => apiUserResponse);

      when(() => authenticationClient.user).thenAnswer(
        (_) => Stream.fromIterable([user]),
      );

      when(() => inAppPurchase.purchaseStream).thenAnswer(
        (_) => Stream.value([
          PurchaseDetails(
            purchaseID: 'purchaseID',
            productID: 'productID',
            verificationData: PurchaseVerificationData(
              localVerificationData: 'local',
              serverVerificationData: 'server',
              source: 'source',
            ),
            transactionDate: 'transactionDate',
            status: PurchaseStatus.pending,
          ),
        ]),
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

    group('fetchSubscriptions', () {
      late InAppPurchaseRepository repository;
      setUp(() {
        repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        when(apiClient.getSubscriptions).thenAnswer(
          (_) async => SubscriptionsResponse(
            subscriptions: [subscription],
          ),
        );
      });

      group('calls apiClient.getSubscriptions ', () {
        test(
            'which returns cachedProducts list '
            'and calls getSubscriptions only once '
            'when cachedProducts is not empty', () async {
          final result = await repository.fetchSubscriptions();
          final nextResult = await repository.fetchSubscriptions();

          verify(apiClient.getSubscriptions).called(1);

          expect(
            result,
            equals(nextResult),
          );
        });

        test(
            'and returns server products list '
            'when cachedProducts is empty', () async {
          final result = await repository.fetchSubscriptions();

          expect(
            result,
            equals([subscription]),
          );
        });

        test(
            'and throws FetchSubscriptionsFailure '
            'when getSubscriptions fails', () async {
          when(apiClient.getSubscriptions).thenThrow(Exception());

          expect(
            repository.fetchSubscriptions(),
            throwsA(isA<FetchSubscriptionsFailure>()),
          );
        });
      });
    });

    group('purchase', () {
      late InAppPurchaseRepository repository;

      setUp(() {
        repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );
        when(
          () => inAppPurchase.buyNonConsumable(
            purchaseParam: any(named: 'purchaseParam'),
          ),
        ).thenAnswer((_) async => true);
      });

      group('calls InAppPurchase.buyNonConsumable ', () {
        setUp(() {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (_) async => ProductDetailsResponse(
              productDetails: [product],
              notFoundIDs: [],
            ),
          );
        });

        test('and finishes successfully', () async {
          await repository.purchase(subscription: subscription);

          verify(
            () => inAppPurchase.buyNonConsumable(
              purchaseParam: any(named: 'purchaseParam'),
            ),
          ).called(1);
        });

        test(
            'and throws InAppPurchaseBuyNonConsumableFailure '
            'when buyNonConsumable fails', () async {
          when(
            () => inAppPurchase.buyNonConsumable(
              purchaseParam: any(named: 'purchaseParam'),
            ),
          ).thenAnswer((_) async => false);

          expect(
            repository.purchase(subscription: subscription),
            throwsA(isA<InAppPurchaseBuyNonConsumableFailure>()),
          );
        });
      });

      group('throws QueryInAppProductDetailsFailure', () {
        test('when productDetailsResponse.error is not null', () {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (_) async => ProductDetailsResponse(
              productDetails: [],
              error: IAPError(
                source: 'source',
                code: 'code',
                message: 'message',
              ),
              notFoundIDs: [],
            ),
          );

          expect(
            repository.purchase(subscription: subscription),
            throwsA(isA<QueryInAppProductDetailsFailure>()),
          );
        });

        test('when productDetailsResponse.productDetails isEmpty', () {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (_) async => ProductDetailsResponse(
              productDetails: [],
              notFoundIDs: [],
            ),
          );

          expect(
            repository.purchase(subscription: subscription),
            throwsA(isA<QueryInAppProductDetailsFailure>()),
          );
        });

        test('when productDetailsResponse.productDetails length > 1', () {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (_) async => ProductDetailsResponse(
              productDetails: [product, product],
              notFoundIDs: [],
            ),
          );

          expect(
            repository.purchase(subscription: subscription),
            throwsA(isA<QueryInAppProductDetailsFailure>()),
          );
        });
      });
    });

    group('restorePurchases ', () {
      late InAppPurchaseRepository repository;

      setUp(() {
        repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );
        when(
          () => inAppPurchase.buyNonConsumable(
            purchaseParam: any(named: 'purchaseParam'),
          ),
        ).thenAnswer((_) async => true);
      });

      test(
          'calls InAppPurchase.restorePurchases '
          'when user is not anonymous', () async {
        when(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(named: 'applicationUserName'),
          ),
        ).thenAnswer((_) async {});

        when(() => authenticationClient.user).thenAnswer(
          (_) => Stream.fromIterable([user]),
        );

        await repository.restorePurchases();

        verify(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(
              named: 'applicationUserName',
            ),
          ),
        ).called(1);
      });

      test(
          'does not call InAppPurchase.restorePurchases '
          'when user is anonymous', () async {
        when(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(named: 'applicationUserName'),
          ),
        ).thenAnswer((_) async {});

        when(() => authenticationClient.user).thenAnswer(
          (_) => Stream.fromIterable([AuthenticationUser.anonymous]),
        );

        await repository.restorePurchases();

        verifyNever(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(
              named: 'applicationUserName',
            ),
          ),
        );
      });
    });

    group('onPurchaseUpdated', () {
      final purchaseDetails = PurchaseDetails(
        status: PurchaseStatus.pending,
        productID: product.id,
        transactionDate: 'transactionDate',
        verificationData: PurchaseVerificationData(
          localVerificationData: 'localVerificationData',
          serverVerificationData: 'server',
          source: 'source',
        ),
      );

      setUp(() {
        when(apiClient.getSubscriptions).thenAnswer(
          (_) async => SubscriptionsResponse(
            subscriptions: [subscription],
          ),
        );
      });

      test(
          'adds PurchaseCanceled event '
          'when PurchaseDetails status is canceled', () {
        when(() => inAppPurchase.purchaseStream).thenAnswer(
          (_) => Stream.fromIterable([
            [purchaseDetails.copyWith(status: PurchaseStatus.canceled)],
          ]),
        );

        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        expectLater(
          repository.purchaseUpdate,
          emits(isA<PurchaseCanceled>()),
        );
      });

      test(
          'adds PurchaseFailed event '
          'when PurchaseDetails status is error', () {
        when(() => inAppPurchase.purchaseStream).thenAnswer(
          (_) => Stream.fromIterable([
            [purchaseDetails.copyWith(status: PurchaseStatus.error)],
          ]),
        );

        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        expectLater(
          repository.purchaseUpdate,
          emits(isA<PurchaseFailed>()),
        );
      });

      group('when PurchaseDetails status is purchased', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (_) => Stream.fromIterable([
              [purchaseDetails.copyWith(status: PurchaseStatus.purchased)],
            ]),
          );
        });

        test(
            'adds PurchasePurchased event '
            'calls apiClient.createSubscription '
            'adds PurchaseDelivered event '
            'adds purchased subscription to currentSubscriptionPlanStream',
            () async {
          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emitsInOrder(
              <Matcher>[
                isA<PurchasePurchased>(),
                isA<PurchaseDelivered>(),
              ],
            ),
          );

          verify(
            () => apiClient.createSubscription(
              subscriptionId: any(named: 'subscriptionId'),
            ),
          ).called(1);
        });

        test(
            'adds PurchasePurchased event '
            'and throws PurchaseFailed '
            'when apiClient.createSubscription throws', () async {
          when(
            () => apiClient.createSubscription(
              subscriptionId: any(named: 'subscriptionId'),
            ),
          ).thenThrow(Exception());

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          expect(
            repository.purchaseUpdate,
            emitsInOrder(
              <Matcher>[
                isA<PurchasePurchased>(),
                emitsError(isA<PurchaseFailed>())
              ],
            ),
          );
        });
      });

      group('when PurchaseDetails status is restored', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (_) => Stream.fromIterable([
              [purchaseDetails.copyWith(status: PurchaseStatus.restored)],
            ]),
          );
        });

        test(
            'adds PurchasePurchased event '
            'calls apiClient.createSubscription '
            'adds PurchaseDelivered event '
            'adds purchased subscription to currentSubscriptionPlanStream',
            () async {
          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emitsInOrder(
              <Matcher>[
                isA<PurchasePurchased>(),
                isA<PurchaseDelivered>(),
              ],
            ),
          );

          verify(
            () => apiClient.createSubscription(
              subscriptionId: any(named: 'subscriptionId'),
            ),
          ).called(1);
        });

        test(
            'adds PurchasePurchased event '
            'and throws PurchaseFailed '
            'when apiClient.createSubscription throws', () async {
          when(
            () => apiClient.createSubscription(
              subscriptionId: any(named: 'subscriptionId'),
            ),
          ).thenThrow(Exception());

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emitsInOrder(<Matcher>[
              isA<PurchasePurchased>(),
              emitsError(isA<PurchaseFailed>()),
            ]),
          );
        });
      });

      group('when pendingCompletePurchase is true', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (_) => Stream.fromIterable([
              [
                purchaseDetails.copyWith(
                  status: PurchaseStatus.pending,
                  pendingCompletePurchase: true,
                )
              ],
            ]),
          );
        });

        test(
            'emits PurchaseCompleted '
            'when inAppPurchase.completePurchase succeeds', () async {
          when(
            () => inAppPurchase.completePurchase(any()),
          ).thenAnswer((_) async {});

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emits(isA<PurchaseCompleted>()),
          );
        });

        test(
            'throws PurchaseFailed '
            'when inAppPurchase.completePurchase fails', () async {
          when(
            () => inAppPurchase.completePurchase(any()),
          ).thenThrow(Exception());

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emitsError(
              isA<PurchaseFailed>(),
            ),
          );
        });

        test(
            'calls apiClient.getSubscriptions once '
            'and returns cachedProducts on next '
            'apiClient.getSubscriptions call', () async {
          when(
            () => inAppPurchase.completePurchase(any()),
          ).thenAnswer((_) async {});
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (_) => Stream.fromIterable([
              [
                purchaseDetails.copyWith(
                  status: PurchaseStatus.pending,
                  pendingCompletePurchase: true,
                ),
                purchaseDetails.copyWith(
                  status: PurchaseStatus.pending,
                  pendingCompletePurchase: true,
                )
              ],
            ]),
          );

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdate,
            emitsInOrder(
              <Matcher>[
                isA<PurchaseCompleted>(),
                isA<PurchaseCompleted>(),
              ],
            ),
          );
        });
      });
    });

    group('fetchSubscriptions', () {
      test('returns subscription list from apiClient.getSubscriptions',
          () async {
        when(apiClient.getSubscriptions).thenAnswer(
          (_) async => SubscriptionsResponse(
            subscriptions: [subscription],
          ),
        );
        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        final result = await repository.fetchSubscriptions();

        expect(result, equals([subscription]));
        verify(
          apiClient.getSubscriptions,
        ).called(1);
      });

      test(
          'throws FetchSubscriptionsFailure '
          'when apiClient.getSubscriptions throws', () async {
        when(apiClient.getSubscriptions).thenThrow(Exception());

        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        expect(
          repository.fetchSubscriptions,
          throwsA(isA<FetchSubscriptionsFailure>()),
        );
      });
    });
  });

  group('PurchaseUpdate', () {
    group('PurchaseDelivered', () {
      test('supports value comparisons', () {
        final event1 = PurchaseDelivered(
          subscription: Subscription(
            benefits: const [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );
        final event2 = PurchaseDelivered(
          subscription: Subscription(
            benefits: const [],
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

    group('PurchaseCompleted', () {
      test('supports value comparisons', () {
        final event1 = PurchaseCompleted(
          subscription: Subscription(
            benefits: const [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );
        final event2 = PurchaseCompleted(
          subscription: Subscription(
            benefits: const [],
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

    group('PurchasePurchased', () {
      test('supports value comparisons', () {
        final event1 = PurchasePurchased(
          subscription: Subscription(
            benefits: const [],
            cost: SubscriptionCost(
              annual: 0,
              monthly: 0,
            ),
            id: '1',
            name: SubscriptionPlan.none,
          ),
        );
        final event2 = PurchasePurchased(
          subscription: Subscription(
            benefits: const [],
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

    group('PurchaseFailed', () {
      test('supports value comparisons', () {
        final event1 = PurchaseFailed(
          failure: DeliverInAppPurchaseFailure('error'),
        );
        final event2 = PurchaseFailed(
          failure: DeliverInAppPurchaseFailure('error'),
        );

        expect(event1, equals(event2));
      });
    });

    group('PurchaseCanceled', () {
      test('supports value comparisons', () {
        final event1 = PurchaseCanceled();
        final event2 = PurchaseCanceled();

        expect(event1, equals(event2));
      });
    });
  });
}

/// Extension on [PurchaseDetails] enabling copyWith.
extension _PurchaseDetailsCopyWith on PurchaseDetails {
  /// Returns a copy of the current PurchaseDetails with the given parameters.
  PurchaseDetails copyWith({
    String? purchaseID,
    String? productID,
    PurchaseVerificationData? verificationData,
    String? transactionDate,
    PurchaseStatus? status,
    bool? pendingCompletePurchase,
  }) =>
      PurchaseDetails(
        purchaseID: purchaseID ?? this.purchaseID,
        productID: productID ?? this.productID,
        verificationData: verificationData ?? this.verificationData,
        transactionDate: transactionDate ?? this.transactionDate,
        status: status ?? this.status,
      )..pendingCompletePurchase =
          pendingCompletePurchase ?? this.pendingCompletePurchase;
}
