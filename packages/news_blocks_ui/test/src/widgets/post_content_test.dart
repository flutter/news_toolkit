// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostContent', () {
    testWidgets('renders correctly with title', (tester) async {
      final testPostContent = PostContent(
        title: 'title',
        premiumText: 'premiumText',
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(
        find.text('title'),
        findsOneWidget,
      );
    });

    testWidgets('renders category when isPremium is false', (tester) async {
      final testPostContent = PostContent(
        title: 'title',
        categoryName: 'categoryName',
        premiumText: 'premiumText',
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(
        find.byType(PostContentCategory),
        findsOneWidget,
      );
      expect(
        find.byType(PostContentPremiumCategory),
        findsNothing,
      );
    });

    testWidgets(
        'renders category and premium '
        'when isPremium is true', (tester) async {
      final testPostContent = PostContent(
        title: 'title',
        categoryName: 'categoryName',
        premiumText: 'premiumText',
        isPremium: true,
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(
        find.byType(PostContentCategory),
        findsOneWidget,
      );
      expect(
        find.byType(PostContentPremiumCategory),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders premium without category '
        'when isPremium is true and categoryName is empty', (tester) async {
      final testPostContent = PostContent(
        title: 'title',
        categoryName: '',
        premiumText: 'premiumText',
        isPremium: true,
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(
        find.byType(PostContentCategory),
        findsNothing,
      );
      expect(
        find.byType(PostContentPremiumCategory),
        findsOneWidget,
      );
    });

    group('renders PostFooter', () {
      testWidgets('when author provided', (tester) async {
        final testPostContent = PostContent(
          title: 'title',
          author: 'author',
          premiumText: 'premiumText',
        );

        await tester.pumpContentThemedApp(testPostContent);

        expect(
          find.byType(PostFooter),
          findsOneWidget,
        );
      });

      testWidgets('when publishedAt provided', (tester) async {
        final testPostContent = PostContent(
          title: 'title',
          publishedAt: DateTime(2000, 12, 31),
          premiumText: 'premiumText',
        );

        await tester.pumpContentThemedApp(testPostContent);

        expect(
          find.byType(PostFooter),
          findsOneWidget,
        );
      });

      testWidgets('when onShare provided', (tester) async {
        final testPostContent = PostContent(
          title: 'title',
          publishedAt: DateTime(2000, 12, 31),
          onShare: () {},
          premiumText: 'premiumText',
        );

        await tester.pumpContentThemedApp(testPostContent);

        expect(
          find.byType(PostFooter),
          findsOneWidget,
        );
      });

      testWidgets('calls onShare when clicked on share icon', (tester) async {
        final completer = Completer<void>();
        final postContent = PostContent(
          publishedAt: DateTime(2000, 12, 31),
          premiumText: 'premiumText',
          title: 'title',
          author: 'author',
          description: 'description',
          categoryName: 'Category',
          onShare: completer.complete,
        );

        await tester.pumpContentThemedApp(postContent);

        await tester.tap(find.byType(IconButton));

        expect(completer.isCompleted, isTrue);
      });
    });
  });
}
