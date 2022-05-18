// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NewsletterSucceeded', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(
        NewsletterSucceeded(
          header: 'header',
          content: Text('center'),
          footer: 'footer',
        ),
      );

      expect(find.byType(NewsletterSucceeded), findsOneWidget);
    });
  });
}
