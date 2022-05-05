// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart'
    show MaterialApp, Scaffold, ColoredBox, Colors;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

void main() {
  group('Spacer', () {
    testWidgets('renders correctly for extraSmall spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.extraSmall),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_extra_small.png'),
      );
    });

    testWidgets('renders correctly for small spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.small),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_small.png'),
      );
    });

    testWidgets('renders correctly for medium spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.medium),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_medium.png'),
      );
    });

    testWidgets('renders correctly for large spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.large),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_large.png'),
      );
    });

    testWidgets('renders correctly for veryLarge spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.veryLarge),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_very_large.png'),
      );
    });

    testWidgets('renders correctly for extraLarge spacing', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: ColoredBox(
            color: Colors.black,
            child: Spacer(
              block: SpacerBlock(spacing: Spacing.extraLarge),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(Spacer),
        matchesGoldenFile('spacing_extra_large.png'),
      );
    });
  });
}
