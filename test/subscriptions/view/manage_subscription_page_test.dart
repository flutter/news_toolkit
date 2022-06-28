// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('ManageSubscriptionPage', () {
    test('has a route', () {
      expect(ManageSubscriptionPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders ManageSubscriptionView', (tester) async {
      await tester.pumpApp(ManageSubscriptionPage());
      expect(find.byType(ManageSubscriptionView), findsOneWidget);
    });
  });

  group('ManageSubscriptionView', () {
    final appBloc = MockAppBloc();

    testWidgets(
        'adds AppUserSubscriptionPlanChanged '
        'when subscriptions ListTile tapped', (tester) async {
      await tester.pumpApp(
        ManageSubscriptionPage(),
        appBloc: appBloc,
      );

      await tester.tap(find.byKey(Key('manageSubscription_subscriptions')));
      await tester.pumpAndSettle();

      verify(
        () => appBloc.add(
          AppUserSubscriptionPlanChanged(
            SubscriptionPlan.none,
          ),
        ),
      ).called(1);
    });
  });
}
