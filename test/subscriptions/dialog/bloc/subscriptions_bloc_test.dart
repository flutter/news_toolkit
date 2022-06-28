// ignore_for_file: prefer_const_constructors

import 'dart:async';

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

    setUp(() {
      inAppPurchaseRepository = MockInAppPurchaseRepository();

      when(
        () => inAppPurchaseRepository.currentSubscriptionPlan,
      ).thenAnswer((_) => Stream.empty());
      when(
        () => inAppPurchaseRepository.purchaseUpdate,
      ).thenAnswer((_) => Stream.empty());
    });

    group('on SubscriptionsRequested ', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'calls InAppPurchaseRepository.fetchSubscriptions '
        'and emits state with fetched subscriptions',
        setUp: () => when(
          inAppPurchaseRepository.fetchSubscriptions,
        ).thenAnswer(
          (_) async => [subscription],
        ),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) => bloc.add(SubscriptionsRequested()),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            subscriptions: [subscription],
          ),
        ],
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds error to state if fetchSubscriptions throws',
        setUp: () => when(
          inAppPurchaseRepository.fetchSubscriptions,
        ).thenThrow(Exception()),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) => bloc.add(SubscriptionsRequested()),
        expect: () => <SubscriptionsState>[],
        errors: () => [isA<Exception>()],
      );
    });

    group(
        'on CurrentSubscriptionChanged '
        'updates currentSubscription', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'when InAppPurchaseRepository.currentSubscriptionPlan changed',
        setUp: () => when(() => inAppPurchaseRepository.currentSubscriptionPlan)
            .thenAnswer((_) => Stream.fromIterable([SubscriptionPlan.premium])),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            currentSubscription: SubscriptionPlan.premium,
          ),
        ],
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds error to state if fetchSubscriptions throws',
        setUp: () => when(
          () => inAppPurchaseRepository.purchase(subscription: subscription),
        ).thenThrow(Exception()),
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        act: (bloc) =>
            bloc.add(SubscriptionPurchaseRequested(subscription: subscription)),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial()
              .copyWith(purchaseStatus: PurchaseStatus.pending)
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('on SubscriptionPurchaseRequested ', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'calls InAppPurchaseRepository.purchase '
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
        act: (bloc) =>
            bloc.add(SubscriptionPurchaseRequested(subscription: subscription)),
        expect: () => <SubscriptionsState>[
          SubscriptionsState.initial().copyWith(
            purchaseStatus: PurchaseStatus.pending,
          ),
        ],
      );
    });

    group('when InAppPurchaseRepository.purchaseUpdate', () {
      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'adds PurchasePurchased '
        'changes purchaseStatus to pending',
        seed: () => SubscriptionsState.initial().copyWith(
          purchaseStatus: PurchaseStatus.none,
        ),
        setUp: () => when(
          () => inAppPurchaseRepository.purchaseUpdate,
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
          () => inAppPurchaseRepository.purchaseUpdate,
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
          () => inAppPurchaseRepository.purchaseUpdate,
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
          () => inAppPurchaseRepository.purchaseUpdate,
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

    group('close', () {
      late StreamController<SubscriptionPlan> currentSubscriptionPlanController;
      late StreamController<PurchaseUpdate>
          subscriptionPurchaseUpdateController;

      setUp(() {
        currentSubscriptionPlanController =
            StreamController<SubscriptionPlan>();
        subscriptionPurchaseUpdateController =
            StreamController<PurchaseUpdate>();

        when(() => inAppPurchaseRepository.currentSubscriptionPlan)
            .thenAnswer((_) => currentSubscriptionPlanController.stream);
        when(() => inAppPurchaseRepository.purchaseUpdate)
            .thenAnswer((_) => subscriptionPurchaseUpdateController.stream);
      });

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'cancels InAppPurchaseRepository.currentSubscriptionPlan subscription',
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        tearDown: () =>
            expect(currentSubscriptionPlanController.hasListener, isFalse),
      );

      blocTest<SubscriptionsBloc, SubscriptionsState>(
        'cancels InAppPurchaseRepository.purchaseUpdate subscription',
        build: () => SubscriptionsBloc(
          inAppPurchaseRepository: inAppPurchaseRepository,
        ),
        tearDown: () =>
            expect(subscriptionPurchaseUpdateController.hasListener, isFalse),
      );
    });
  });
}
