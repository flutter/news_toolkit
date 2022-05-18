// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NewsletterSignUp', () {
    testWidgets('renders correctly', (tester) async {
      final widget = NewsletterSignUp(
        headerText: 'header',
        bodyText: 'body',
        email: Text('email'),
        buttonText: 'buttonText',
        onPressed: null,
      );

      await tester.pumpApp(widget);

      expect(find.byType(NewsletterSignUp), findsOneWidget);
    });

    testWidgets('onPressed is called on tap', (tester) async {
      final completer = Completer<void>();

      final widget = NewsletterSignUp(
        headerText: 'header',
        bodyText: 'body',
        email: Text('email'),
        buttonText: 'buttonText',
        onPressed: completer.complete,
      );

      await tester.pumpApp(widget);

      await tester.tap(find.byType(AppButton));

      expect(completer.isCompleted, isTrue);
    });
  });
}
