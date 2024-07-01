// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('TextHeadline', () {
    setUpAll(
      () => setUpTolerantComparator('test/src/text_headline_test.dart'),
    );

    testWidgets('renders correctly', (tester) async {
      final widget = Center(
        child: TextHeadline(
          block: TextHeadlineBlock(text: 'Title text'),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(TextHeadline),
        matchesGoldenFile('text_headline.png'),
      );
    });
  });
}
