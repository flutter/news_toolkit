// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:{{project_name.snakeCase()}}/subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NavDrawerSubscribe', () {
    testWidgets('renders NavDrawerSubscribeTitle', (tester) async {
      await tester.pumpApp(NavDrawerSubscribe());
      expect(find.byType(NavDrawerSubscribeTitle), findsOneWidget);
    });

    testWidgets('renders NavDrawerSubscribeSubtitle', (tester) async {
      await tester.pumpApp(NavDrawerSubscribe());
      expect(find.byType(NavDrawerSubscribeSubtitle), findsOneWidget);
    });

    testWidgets('renders NavDrawerSubscribeButton', (tester) async {
      await tester.pumpApp(NavDrawerSubscribe());
      expect(find.byType(NavDrawerSubscribeButton), findsOneWidget);
    });

    group('NavDrawerSubscribeButton', () {
      testWidgets('renders AppButton', (tester) async {
        await tester.pumpApp(NavDrawerSubscribeButton());
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
          NavDrawerSubscribeButton(),
          inAppPurchaseRepository: inAppPurchaseRepository,
        );
        await tester.tap(find.byType(NavDrawerSubscribeButton));
        await tester.pump();

        expect(find.byType(PurchaseSubscriptionDialog), findsOneWidget);
      });
    });
  });
}
