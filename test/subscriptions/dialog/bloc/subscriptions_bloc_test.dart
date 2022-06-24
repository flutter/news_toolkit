// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockInAppPurchaseRepository extends Mock
    implements InAppPurchaseRepository {}

void main() {
  group('SubscriptionBloc', () {
    late InAppPurchaseRepository inAppPurchaseRepository;

    final subscription = Subscription(
      id: 'dd339fda-33e9-49d0-9eb5-0ccb77eb760f',
      name: SubscriptionPlan.none,
      cost: SubscriptionCost(
        annual: 16200,
        monthly: 1499,
      ),
      benefits: const [
        'test benefits',
        'another test benefits',
      ],
    );

    setUpAll(() {
      inAppPurchaseRepository = MockInAppPurchaseRepository();

      when(
        () => inAppPurchaseRepository.currentSubscriptionPlan,
      ).thenAnswer((_) => Stream.value(SubscriptionPlan.none));
      when(
        () => inAppPurchaseRepository.purchaseUpdateStream,
      ).thenAnswer((_) => Stream.empty());
    });

    group('on SubscriptionsRequested ', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'calls inAppPurchaseRepository.fetchSubscriptions '
        'and emits state with fetched subscriptions',
        setUp: () => when(
          () => inAppPurchaseRepository.fetchSubscriptions(),
        ).thenAnswer(
          (_) async => [subscription],
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) {
          bloc.add(SubscriptionsRequested());
        },
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            subscriptions: [subscription],
          ),
        ],
      );
    });

    group('on CurrentSubscriptionChanged ', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'and emits state with currentSubscription changed',
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) {
          bloc.add(CurrentSubscriptionChanged(subscription: subscription.name));
        },
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            currentSubscription: subscription.name,
          ),
        ],
      );
    });

    group('on SubscriptionPurchaseRequested ', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'calls inAppPurchaseRepository.purchase '
        'and emits pending state',
        setUp: () => when(
          () => inAppPurchaseRepository.purchase(
            subscription: subscription,
          ),
        ).thenAnswer(
          (_) async {},
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) {
          bloc.add(SubscriptionPurchaseRequested(subscription: subscription));
        },
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.pending,
          ),
        ],
      );
    });

    group('when _inAppPurchaseRepository.purchaseUpdateStream', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds PurchasePurchased '
        'changes purchaseStatus to pending',
        seed: () => SubscriptionsState.initial().copyWith(
          purchaseStatus: PurchaseStatus.none,
        ),
        setUp: () => when(
          () => inAppPurchaseRepository.purchaseUpdateStream,
        ).thenAnswer(
          (_) => Stream.value(
            PurchasePurchased(
              subscription: subscription,
            ),
          ),
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.pending,
          ),
        ],
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds PurchaseDelivered '
        'changes purchaseStatus to completed',
        seed: () => SubscriptionsState.initial().copyWith(
          purchaseStatus: PurchaseStatus.pending,
        ),
        setUp: () => when(
          () => inAppPurchaseRepository.purchaseUpdateStream,
        ).thenAnswer(
          (_) => Stream.value(
            PurchaseDelivered(
              subscription: subscription,
            ),
          ),
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.completed,
          ),
        ],
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds PurchaseDelivered '
        'changes purchaseStatus to completed',
        seed: () => SubscriptionsState.initial().copyWith(
          purchaseStatus: PurchaseStatus.pending,
        ),
        setUp: () => when(
          () => inAppPurchaseRepository.purchaseUpdateStream,
        ).thenAnswer(
          (_) => Stream.value(
            PurchaseFailed(
              failure: InternalInAppPurchaseFailure(subscription),
            ),
          ),
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.failed,
          ),
        ],
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds PurchaseDelivered '
        'changes purchaseStatus to completed',
        seed: () => SubscriptionsState.initial().copyWith(
          purchaseStatus: PurchaseStatus.pending,
        ),
        setUp: () => when(
          () => inAppPurchaseRepository.purchaseUpdateStream,
        ).thenAnswer(
          (_) => Stream.value(
            PurchaseCanceled(),
          ),
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.failed,
          ),
        ],
      );
    });
  });
}
