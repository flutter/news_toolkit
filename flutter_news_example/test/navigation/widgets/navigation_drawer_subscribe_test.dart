// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter_news_example/navigation/navigation.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NavigationDrawerSubscribe', () {
    testWidgets('renders NavigationDrawerSubscribeTitle', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeTitle), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSubscribeSubtitle', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeSubtitle), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSubscribeButton', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeButton), findsOneWidget);
    });

    group('NavigationDrawerSubscribeButton', () {
      testWidgets('renders AppButton', (tester) async {
        await tester.pumpApp(NavigationDrawerSubscribeButton());
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('opens PurchaseSubscriptionDialog when tapped',
          (tester) async {
        final inAppPurchaseRepository = MockInAppPurchaseRepository();

        when(
          () => inAppPurchaseRepository.purchaseUpdate,
        ).thenAnswer((_) => Stream.empty());

        when(
          inAppPurchaseRepository.fetchSubscriptions,
        ).thenAnswer((_) async => []);

        await tester.pumpApp(
          NavigationDrawerSubscribeButton(),
          inAppPurchaseRepository: inAppPurchaseRepository,
        );
        await tester.tap(find.byType(NavigationDrawerSubscribeButton));
        await tester.pump();

        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
      });
    });
  });
}
