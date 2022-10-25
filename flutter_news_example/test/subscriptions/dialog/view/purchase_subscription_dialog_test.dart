import 'dart:async';

import 'package:app_ui/app_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/analytics/analytics.dart';
import 'package:flutter_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart'
    hide PurchaseCompleted;
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../../helpers/helpers.dart';

void main() {
  late InAppPurchaseRepository inAppPurchaseRepository;
  late UserRepository userRepository;

  const subscription = Subscription(
    id: 'dd339fda-33e9-49d0-9eb5-0ccb77eb760f',
    name: SubscriptionPlan.premium,
    cost: SubscriptionCost(
      annual: 16200,
      monthly: 1499,
    ),
    benefits: [
      'first',
      'second',
      'third',
    ],
  );

  setUp(() {
    inAppPurchaseRepository = MockInAppPurchaseRepository();
    userRepository = MockUserRepository();

    when(() => inAppPurchaseRepository.purchaseUpdate).thenAnswer(
      (_) => const Stream.empty(),
    );

    when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
      (_) async => [],
    );

    when(
      userRepository.updateSubscriptionPlan,
    ).thenAnswer((_) async {});
  });

  group('showPurchaseSubscriptionDialog', () {
    testWidgets('renders PurchaseSubscriptionDialog', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              key: const Key('tester_elevatedButton'),
              child: const Text('test'),
              onPressed: () => showPurchaseSubscriptionDialog(context: context),
            );
          },
        ),
        inAppPurchaseRepository: inAppPurchaseRepository,
      );

      await tester.tap(find.byKey(const Key('tester_elevatedButton')));

      await tester.pump();

      expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
    });
  });

  group('PurchaseSubscriptionDialog', () {
    testWidgets(
      'renders PurchaseSubscriptionDialogView',
      (WidgetTester tester) async {
        await tester.pumpApp(
          const PurchaseSubscriptionDialog(),
          inAppPurchaseRepository: inAppPurchaseRepository,
        );
        expect(find.byType(PurchaseSubscriptionDialogView), findsOneWidget);
      },
    );
  });

  group('PurchaseSubscriptionDialogView', () {
    testWidgets('renders list of SubscriptionCard', (tester) async {
      const otherSubscription = Subscription(
        id: 'other_subscription_id',
        name: SubscriptionPlan.premium,
        cost: SubscriptionCost(
          annual: 16200,
          monthly: 1499,
        ),
        benefits: [
          'first',
          'second',
          'third',
        ],
      );

      final subscriptions = [
        subscription,
        otherSubscription,
      ];

      when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
        (_) async => subscriptions,
      );
      await tester.pumpApp(
        const PurchaseSubscriptionDialog(),
        inAppPurchaseRepository: inAppPurchaseRepository,
      );

      for (final subscription in subscriptions) {
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is SubscriptionCard &&
                widget.key == ValueKey(subscription),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('closes dialog on close button tap', (tester) async {
      final navigator = MockNavigator();

      when(navigator.pop).thenAnswer((_) async => true);

      await tester.pumpApp(
        const PurchaseSubscriptionDialog(),
        inAppPurchaseRepository: inAppPurchaseRepository,
        navigator: navigator,
      );
      await tester.pump();
      await tester.tap(
        find.byKey(
          const Key('purchaseSubscriptionDialog_closeIconButton'),
        ),
      );
      await tester.pump();

      verify(navigator.pop).called(1);
    });

    testWidgets(
        'shows PurchaseCompleted dialog '
        'and adds UserSubscriptionConversionEvent to AnalyticsBloc '
        'when SubscriptionsBloc emits purchaseStatus.completed',
        (tester) async {
      final navigator = MockNavigator();
      final analyticsBloc = MockAnalyticsBloc();

      when(navigator.maybePop<void>).thenAnswer((_) async => true);

      when(
        () => inAppPurchaseRepository.purchaseUpdate,
      ).thenAnswer(
        (_) => Stream.fromIterable(
          [const PurchaseDelivered(subscription: subscription)],
        ),
      );

      await tester.pumpApp(
        const PurchaseSubscriptionDialog(),
        navigator: navigator,
        inAppPurchaseRepository: inAppPurchaseRepository,
        analyticsBloc: analyticsBloc,
        userRepository: userRepository,
      );

      await tester.pump();
      expect(find.byType(PurchaseCompletedDialog), findsOneWidget);

      verify(
        () => analyticsBloc.add(
          TrackAnalyticsEvent(
            UserSubscriptionConversionEvent(),
          ),
        ),
      ).called(1);
    });
  });

  group('PurchaseCompletedDialog', () {
    testWidgets('closes after 3 seconds', (tester) async {
      const buttonText = 'buttonText';

      await tester.pumpApp(
        Builder(
          builder: (context) {
            return AppButton.black(
              child: const Text('buttonText'),
              onPressed: () => showAppModal<void>(
                context: context,
                builder: (context) => const PurchaseCompletedDialog(),
              ),
            );
          },
        ),
        inAppPurchaseRepository: inAppPurchaseRepository,
      );

      await tester.tap(find.text(buttonText));
      await tester.pump();
      expect(find.byType(PurchaseCompletedDialog), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.pump();
      expect(find.byType(PurchaseCompletedDialog), findsNothing);
    });
  });
}
