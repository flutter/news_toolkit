// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscribe/subscribe.dart';

import '../../helpers/helpers.dart';

void main() {
  testWidgets('renders SubscribeWhiteShadow', (tester) async {
    await tester.pumpApp(
      Stack(
        children: [
          SubscribeWhiteShadow(
            child: Container(),
          ),
        ],
      ),
    );

    expect(find.byType(SubscribeWhiteShadow), findsOneWidget);
  });
}
