// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide Spacer, Image;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CategoryFeedItem', () {
    testWidgets(
        'renders DividerHorizontal '
        'for DividerHorizontalBlock', (tester) async {
      const block = DividerHorizontalBlock();
      await tester.pumpApp(CategoryFeedItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DividerHorizontal && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Spacer '
        'for SpacerBlock', (tester) async {
      const block = SpacerBlock(spacing: Spacing.large);
      await tester.pumpApp(CategoryFeedItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Spacer && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders SectionHeader '
        'for SectionHeaderBlock', (tester) async {
      const block = SectionHeaderBlock(title: 'title');
      await tester.pumpApp(CategoryFeedItem(block: block));
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SectionHeader && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostLarge '
        'for PostLargeBlock', (tester) async {
      final block = PostLargeBlock(
        id: 'id',
        category: PostCategory.technology,
        author: 'author',
        publishedAt: DateTime(2022, 3, 9),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          ListView(
            children: [
              CategoryFeedItem(block: block),
            ],
          ),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostLarge && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostMedium '
        'for PostMediumBlock', (tester) async {
      final block = PostMediumBlock(
        id: 'id',
        category: PostCategory.sports,
        author: 'author',
        publishedAt: DateTime(2022, 3, 10),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(CategoryFeedItem(block: block));
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostMedium && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostSmall '
        'for PostSmallBlock', (tester) async {
      final block = PostSmallBlock(
        id: 'id',
        category: PostCategory.health,
        author: 'author',
        publishedAt: DateTime(2022, 3, 11),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(CategoryFeedItem(block: block));
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostSmall && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostGrid '
        'for PostGridGroupBlock', (tester) async {
      final block = PostGridGroupBlock(
        category: PostCategory.science,
        tiles: [
          PostGridTileBlock(
            id: 'id',
            category: PostCategory.science,
            author: 'author',
            publishedAt: DateTime(2022, 3, 12),
            imageUrl: 'imageUrl',
            title: 'title',
          )
        ],
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          ListView(
            children: [
              CategoryFeedItem(block: block),
            ],
          ),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostGrid && widget.gridGroupBlock == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Image '
        'for ImageBlock', (tester) async {
      final block = ImageBlock(
        imageUrl: 'imageUrl',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(CategoryFeedItem(block: block));
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Image && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders SizedBox '
        'for unsupported block', (tester) async {
      final block = UnknownBlock();
      await tester.pumpApp(CategoryFeedItem(block: block));
      expect(
        find.byType(SizedBox),
        findsOneWidget,
      );
    });
  });
}
