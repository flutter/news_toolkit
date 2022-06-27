import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('SubscriptionCard', () {
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

    group('when isExpanded is set to true', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpApp(
          const SubscriptionCard(
            isExpanded: true,
            subscription: subscription,
          ),
        );

        for (final benefit in subscription.benefits) {
          expect(find.byKey(ValueKey(benefit)), findsOneWidget);
        }

        expect(
          find.byKey(const Key('subscriptionCard_subscribeButton')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('subscriptionCard_outlinedButton')),
          findsNothing,
        );
      });

      testWidgets('opens PurchaseSubscriptionDialog on subscribeButton tap',
          (tester) async {
        final inAppPurchaseRepository = MockInAppPurchaseRepository();

        when(
          () => inAppPurchaseRepository.currentSubscriptionPlan,
        ).thenAnswer(
          (_) => Stream.fromIterable([
            SubscriptionPlan.none,
          ]),
        );

        when(() => inAppPurchaseRepository.purchaseUpdateStream).thenAnswer(
          (_) => const Stream.empty(),
        );

        when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
          (invocation) async => [],
        );
        await tester.pumpApp(
          const SubscriptionCard(
            isExpanded: true,
            subscription: subscription,
          ),
          inAppPurchaseRepository: inAppPurchaseRepository,
        );

        await tester
            .tap(find.byKey(const Key('subscriptionCard_subscribeButton')));

        await tester.pump();

        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
      });
    });

    group('when isExpanded is set to false', () {
      testWidgets('renders correctly', (tester) async {
        await tester.pumpApp(
          const SubscriptionCard(
            subscription: subscription,
          ),
        );

        for (final benefit in subscription.benefits) {
          expect(find.byKey(ValueKey(benefit)), findsOneWidget);
        }

        expect(
          find.byKey(const Key('subscriptionCard_subscribeButton')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('subscriptionCard_outlinedButton')),
          findsOneWidget,
        );
      });

      testWidgets('shows SnackBar on outlinedButton tap', (tester) async {
        await tester.pumpApp(
          const SubscriptionCard(
            subscription: subscription,
          ),
        );

        final snackBarFinder = find.byKey(
          const Key(
            'subscriptionCard_unimplemented_snackBar',
          ),
        );

        expect(snackBarFinder, findsNothing);
        await tester
            .tap(find.byKey(const Key('subscriptionCard_outlinedButton')));
        await tester.pump();
        expect(snackBarFinder, findsOneWidget);
      });
    });

    testWidgets('renders bestValue Icon when isBestValue is true',
        (tester) async {
      await tester.pumpApp(
        const SubscriptionCard(
          isBestValue: true,
          subscription: subscription,
        ),
      );
      expect(
        find.byKey(const Key('subscriptionCard_bestValueSvg')),
        findsOneWidget,
      );
    });
  });
}
