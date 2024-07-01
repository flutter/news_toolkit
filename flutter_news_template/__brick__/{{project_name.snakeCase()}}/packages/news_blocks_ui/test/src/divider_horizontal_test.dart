// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('DividerHorizontal', () {
    setUpAll(
      () => setUpTolerantComparator('test/src/divider_horizontal_test.dart'),
    );

    testWidgets('renders correctly', (tester) async {
      final widget = Center(
        child: DividerHorizontal(
          block: DividerHorizontalBlock(),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(DividerHorizontal),
        matchesGoldenFile('divider_horizontal.png'),
      );
    });
  });
}
