// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('TextCaption', () {
    setUpAll(setUpTolerantComparator);

    testWidgets('renders correctly with normal color', (tester) async {
      final widget = Center(
        child: TextCaption(
          block: TextCaptionBlock(
            text: 'Text caption',
            color: TextCaptionColor.normal,
          ),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(TextCaption),
        matchesGoldenFile('text_caption_normal_color.png'),
      );
    });

    testWidgets('renders correctly with light color', (tester) async {
      final widget = Center(
        child: TextCaption(
          block: TextCaptionBlock(
            text: 'Text caption',
            color: TextCaptionColor.light,
          ),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(TextCaption),
        matchesGoldenFile('text_caption_light_color.png'),
      );
    });
  });
}
