// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscribe/subscribe.dart';

import '../../helpers/helpers.dart';

void main() {
  const subscribeButtonKey = Key('subscribeLoggedIn_subscribeButton');
  testWidgets('renders SubscribeLoggedIn', (tester) async {
    await tester.pumpApp(SubscribeLoggedInOutModal());

    expect(find.byType(SubscribeLoggedInOutModal), findsOneWidget);
  });

  testWidgets('does nothing when tap on subscribe button', (tester) async {
    await tester.pumpApp(SubscribeLoggedInOutModal());
    await tester.tap(find.byKey(subscribeButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(subscribeButtonKey), findsOneWidget);
  });
}
