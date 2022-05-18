// ignore_for_file: unnecessary_const, prefer_const_constructors

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

    testWidgets('renders category', (tester) async {
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
    });
  });
}
