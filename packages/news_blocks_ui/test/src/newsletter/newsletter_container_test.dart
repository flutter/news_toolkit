// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NewsletterContainer', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(NewsletterContainer());

      expect(find.byType(NewsletterContainer), findsOneWidget);
    });
  });
}
