// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:google_news_template_api/client.dart' hide User;
import 'package:google_news_template_api/client.dart' as api;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}

class MockInAppPurchase extends Mock implements InAppPurchase {}

class FakePurchaseDetails extends Fake implements PurchaseDetails {}

class InAppPurchaseException extends InAppPurchasesFailure {
  InAppPurchaseException(super.error, super.stackTrace);
}

void main() {
  test('InAppPurchasesFailure supports value comparison', () {
    expect(
      InAppPurchaseException('error', StackTrace.empty),
      equals(
        InAppPurchaseException('error', StackTrace.empty),
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

    final user = User(
      id: '123',
      name: 'name',
    );

    final subscription = Subscription(
      id: product.id,
      name: SubscriptionPlan.none,
      cost: SubscriptionCost(annual: 1, monthly: 2),
      benefits: const ['benefit', 'nextBenefit'],
    );

    final productDetailsFromSubscription = ProductDetails(
      id: product.id,
      title: subscription.name.toString(),
      description: subscription.benefits.toString(),
      price: subscription.cost.monthly.toString(),
      rawPrice: subscription.cost.monthly.toDouble(),
      currencyCode: 'USD',
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

      when(() => authenticationClient.user).thenAnswer(
        (invocation) => Stream.fromIterable([user]),
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

    test('currentSubscriptionPlan emits none when initialized', () {
      expect(
        InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        ).currentSubscriptionPlan,
        emits(SubscriptionPlan.none),
      );
    });

    group('fetchProducts', () {
      late InAppPurchaseRepository repository;
      setUp(() {
        repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        when(() => apiClient.getSubscriptions()).thenAnswer(
          (invocation) async => SubscriptionsResponse(
            subscriptions: [subscription],
          ),
        );
      });

      group('calls getSubscriptions ', () {
        test(
            'which returns cachedProducts list '
            'and calls getSubscriptions only once '
            'when cachedProducts is not empty', () async {
          final result = await repository.fetchProducts();
          final nextResult = await repository.fetchProducts();

          verify(() => apiClient.getSubscriptions()).called(1);

          expect(
            result.first.equals(nextResult.first),
            isTrue,
          );
        });

        test(
            'and returns cachedProducts list '
            'when cachedProducts is empty', () async {
          final result = await repository.fetchProducts();

          expect(
            result.first.equals(productDetailsFromSubscription),
            isTrue,
          );
        });

        test(
            'and throws FetchInAppProductsFailure '
            'when getSubscriptions fails', () async {
          when(() => apiClient.getSubscriptions())
              .thenThrow(() => FetchInAppProductsFailure);

          expect(
            repository.fetchProducts(),
            throwsA(isA<FetchInAppProductsFailure>()),
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

      group('calls inAppPurchase.buyNonConsumable ', () {
        setUp(() {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (invocation) async => ProductDetailsResponse(
              productDetails: [product],
              notFoundIDs: [],
            ),
          );
        });

        test('and finishes successfully', () async {
          await repository.purchase(product: product);

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
            repository.purchase(product: product),
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
            (invocation) async => ProductDetailsResponse(
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
            repository.purchase(product: product),
            throwsA(isA<QueryInAppProductDetailsFailure>()),
          );
        });

        test('when productDetailsResponse.productDetails isEmpty', () {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (invocation) async => ProductDetailsResponse(
              productDetails: [],
              notFoundIDs: [],
            ),
          );

          expect(
            repository.purchase(product: product),
            throwsA(isA<QueryInAppProductDetailsFailure>()),
          );
        });

        test('when productDetailsResponse.productDetails length > 1', () {
          when(
            () => inAppPurchase.queryProductDetails(
              any(that: isA<Set<String>>()),
            ),
          ).thenAnswer(
            (invocation) async => ProductDetailsResponse(
              productDetails: [product, product],
              notFoundIDs: [],
            ),
          );

          expect(
            repository.purchase(product: product),
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
          'calls inAppPurchase.restorePurchases '
          'when user is not anonymous', () async {
        when(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(named: 'applicationUserName'),
          ),
        ).thenAnswer((invocation) async {});

        when(() => authenticationClient.user).thenAnswer(
          (invocation) => Stream.fromIterable([user]),
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
          'not calls inAppPurchase.restorePurchases '
          'when user is anonymous', () async {
        when(
          () => inAppPurchase.restorePurchases(
            applicationUserName: any(named: 'applicationUserName'),
          ),
        ).thenAnswer((invocation) async {});

        when(() => authenticationClient.user).thenAnswer(
          (invocation) => Stream.fromIterable([User.anonymous]),
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
        when(() => apiClient.getSubscriptions()).thenAnswer(
          (invocation) async => SubscriptionsResponse(
            subscriptions: [subscription],
          ),
        );
      });

      test(
          'adds PurchaseCanceled event '
          'when PurchaseDetails status is canceled', () {
        when(() => inAppPurchase.purchaseStream).thenAnswer(
          (invocation) => Stream.fromIterable([
            [purchaseDetails.copyWith(status: PurchaseStatus.canceled)],
          ]),
        );

        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        expectLater(
          repository.purchaseUpdateStream,
          emits(isA<PurchaseCanceled>()),
        );
      });

      test(
          'adds PurchaseFailed event '
          'when PurchaseDetails status is error', () {
        when(() => inAppPurchase.purchaseStream).thenAnswer(
          (invocation) => Stream.fromIterable([
            [purchaseDetails.copyWith(status: PurchaseStatus.error)],
          ]),
        );

        final repository = InAppPurchaseRepository(
          authenticationClient: authenticationClient,
          apiClient: apiClient,
          inAppPurchase: inAppPurchase,
        );

        expectLater(
          repository.purchaseUpdateStream,
          emits(isA<PurchaseFailed>()),
        );
      });

      group('when PurchaseDetails status is purchased', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (invocation) => Stream.fromIterable([
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
          when(() => apiClient.getCurrentUser()).thenAnswer(
            (invocation) async => CurrentUserResponse(
              user: api.User(
                id: user.id,
                subscription: subscription.name,
              ),
            ),
          );

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdateStream,
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

          await expectLater(
            repository.currentSubscriptionPlan,
            emits(isA<SubscriptionPlan>()),
          );

          await expectLater(
            repository.currentSubscriptionPlan,
            emits(
              isA<SubscriptionPlan>(),
            ),
          );
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

          try {
            final repository = InAppPurchaseRepository(
              authenticationClient: authenticationClient,
              apiClient: apiClient,
              inAppPurchase: inAppPurchase,
            );

            await expectLater(
              repository.purchaseUpdateStream,
              emits(isA<PurchasePurchased>()),
            );
          } catch (e) {
            expect(e, isA<PurchaseFailed>());
          }
        });
      });

      group('when PurchaseDetails status is restored', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (invocation) => Stream.fromIterable([
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
            repository.purchaseUpdateStream,
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

          await expectLater(
            repository.currentSubscriptionPlan,
            emits(isA<SubscriptionPlan>()),
          );
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

          try {
            final repository = InAppPurchaseRepository(
              authenticationClient: authenticationClient,
              apiClient: apiClient,
              inAppPurchase: inAppPurchase,
            );

            await expectLater(
              repository.purchaseUpdateStream,
              emits(isA<PurchasePurchased>()),
            );
          } catch (e) {
            expect(e, isA<PurchaseFailed>());
          }
        });
      });

      group('when pendingCompletePurchase is true', () {
        setUp(() {
          when(() => inAppPurchase.purchaseStream).thenAnswer(
            (invocation) => Stream.fromIterable([
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
          ).thenAnswer((invocation) async {});

          final repository = InAppPurchaseRepository(
            authenticationClient: authenticationClient,
            apiClient: apiClient,
            inAppPurchase: inAppPurchase,
          );

          await expectLater(
            repository.purchaseUpdateStream,
            emits(isA<PurchaseCompleted>()),
          );
        });

        test(
            'throws PurchaseFailed '
            'when inAppPurchase.completePurchase fails', () async {
          when(
            () => inAppPurchase
                .completePurchase(any(that: isA<PurchaseDetails>())),
          ).thenThrow(Exception());

          try {
            InAppPurchaseRepository(
              authenticationClient: authenticationClient,
              apiClient: apiClient,
              inAppPurchase: inAppPurchase,
            );
          } catch (e) {
            expect(e, isA<PurchaseFailed>());
          }
        });
      });
    });
  });
}

/// Extension on [ProductDetails] enabling object comparison.
extension _ProductDetailsEquals on ProductDetails {
  /// Returns a copy of the current ProductDetails with the given parameters.
  bool equals(ProductDetails productDetails) =>
      productDetails.id == id &&
      productDetails.title == title &&
      productDetails.description == description &&
      productDetails.price == price &&
      productDetails.rawPrice == rawPrice &&
      productDetails.currencyCode == currencyCode;
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
