// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/pump_app.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockSubscriptionsBloc
    extends MockBloc<SubscriptionsEvent, SubscriptionsState>
    implements SubscriptionsBloc {}

class MockUser extends Mock implements User {}

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

    group('when isExpanded is true', () {
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
          find.byKey(const Key('subscriptionCard_subscribe_appButton')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('subscriptionCard_viewDetails_appButton')),
          findsNothing,
        );
      });

      testWidgets(
          'adds SubscriptionPurchaseRequested to SubscriptionsBloc '
          'on subscribeButton tap '
          'when user is logged in', (tester) async {
        final inAppPurchaseRepository = MockInAppPurchaseRepository();
        final appBloc = MockAppBloc();
        final SubscriptionsBloc subscriptionsBloc = MockSubscriptionsBloc();

        final user = MockUser();
        when(() => user.subscriptionPlan).thenReturn(SubscriptionPlan.premium);
        when(() => appBloc.state).thenAnswer(
          (_) => AppState.authenticated(user),
        );

        when(() => subscriptionsBloc.state).thenAnswer(
          (_) => SubscriptionsState.initial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: subscriptionsBloc,
            child: Builder(
              builder: (context) {
                return const SubscriptionCard(
                  isExpanded: true,
                  subscription: subscription,
                );
              },
            ),
          ),
          appBloc: appBloc,
          inAppPurchaseRepository: inAppPurchaseRepository,
        );

        await tester
            .tap(find.byKey(const Key('subscriptionCard_subscribe_appButton')));

        await tester.pumpAndSettle();

        verify(
          () => subscriptionsBloc.add(
            SubscriptionPurchaseRequested(
              subscription: subscription,
            ),
          ),
        ).called(1);
      });

      testWidgets(
          'shows LoginModal '
          'on subscribeButton tap '
          'when user is not logged in', (tester) async {
        final inAppPurchaseRepository = MockInAppPurchaseRepository();
        final appBloc = MockAppBloc();
        final SubscriptionsBloc subscriptionsBloc = MockSubscriptionsBloc();

        when(() => appBloc.state).thenAnswer(
          (_) => AppState.unauthenticated(),
        );

        when(() => subscriptionsBloc.state).thenAnswer(
          (_) => SubscriptionsState.initial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: subscriptionsBloc,
            child: Builder(
              builder: (context) {
                return const SubscriptionCard(
                  isExpanded: true,
                  subscription: subscription,
                );
              },
            ),
          ),
          appBloc: appBloc,
          inAppPurchaseRepository: inAppPurchaseRepository,
        );

        await tester
            .tap(find.byKey(const Key('subscriptionCard_subscribe_appButton')));

        await tester.pumpAndSettle();

        expect(find.byType(LoginModal), findsOneWidget);
      });
    });

    group('when isExpanded is false', () {
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
          find.byKey(const Key('subscriptionCard_subscribe_appButton')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('subscriptionCard_viewDetails_appButton')),
          findsOneWidget,
        );
      });

      testWidgets('shows SnackBar on viewDetails tap', (tester) async {
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
        await tester.tap(
          find.byKey(const Key('subscriptionCard_viewDetails_appButton')),
        );
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
