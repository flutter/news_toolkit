// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NewsletterSucceeded', () {
    testWidgets('renders correctly', (tester) async {
      const headerText = 'headerText';
      const contentText = 'contentText';
      const footerText = 'footerText';
      await tester.pumpApp(
        NewsletterSucceeded(
          headerText: headerText,
          content: Text(contentText),
          footerText: footerText,
        ),
      );

      expect(find.text(headerText), findsOneWidget);
      expect(find.text(contentText), findsOneWidget);
      expect(find.text(footerText), findsOneWidget);
    });
  });
}
