// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';

import '../../helpers/helpers.dart';

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
}
