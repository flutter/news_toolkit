// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../helpers/helpers.dart';

void main() {
  setUpAll(() {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;

    setUpTolerantComparator(
      'test/src/post_medium/post_medium_test.dart',
    );
    setUpMockPathProvider();
  });

  group('PostMedium', () {
    const id = '82c49bf1-946d-4920-a801-302291f367b5';
    const category = PostCategory.sports;
    const author = 'Tom Dierberger';
    final publishedAt = DateTime(2022, 3, 10);
    const imageUrl =
        'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg';
    const title = 'No Man’s Sky’s new Outlaws update '
        'lets players go full space pirate';
    const description =
        'No Man’s Sky’s newest update, Outlaws, is now live, and it lets '
        'players find and smuggle black market goods and evade the '
        'authorities in outlaw systems.';

    testWidgets('renders correctly overlaid layout', (tester) async {
      final postMediumBlock = PostMediumBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl,
        title: title,
        description: description,
        isContentOverlaid: true,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          Column(children: [PostMedium(block: postMediumBlock)]),
        ),
      );

      expect(
        find.byType(PostMediumOverlaidLayout),
        matchesGoldenFile('post_medium_overlaid_layout.png'),
      );
    });

    testWidgets('renders correctly description layout', (tester) async {
      final postMediumBlock = PostMediumBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl,
        title: title,
        description: description,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          Column(children: [PostMedium(block: postMediumBlock)]),
        ),
      );

      expect(
        find.byType(PostMediumDescriptionLayout),
        matchesGoldenFile('post_medium_description_layout.png'),
      );
    });

    testWidgets('onPressed is called with action when tapped', (tester) async {
      final action = NavigateToArticleAction(articleId: id);
      final actions = <BlockAction>[];
      final postMediumBlock = PostMediumBlock(
        id: id,
        category: category,
        author: author,
        publishedAt: publishedAt,
        imageUrl: imageUrl,
        title: title,
        description: description,
        action: action,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          PostMedium(
            block: postMediumBlock,
            onPressed: actions.add,
          ),
        ),
      );

      final widget = find.byType(PostMediumDescriptionLayout);

      expect(widget, findsOneWidget);
      await tester.tap(widget);

      expect(actions, [action]);
    });
  });
}
