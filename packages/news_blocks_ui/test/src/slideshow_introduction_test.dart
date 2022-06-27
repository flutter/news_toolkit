// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  group('SlideshowIntroduction', () {
    testWidgets('renders title', (tester) async {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: 'coverImageUrl',
      );

      await tester.pumpContentThemedApp(
        SlideshowIntroduction(block: block, slideshowText: 'slideshowText'),
      );

      expect(find.text(block.title), findsOneWidget);
    });
    testWidgets('renders slideshow category', (tester) async {});

    testWidgets(
      'onPressed is called with action when tapped',
      (tester) async {},
    );
  });
}
