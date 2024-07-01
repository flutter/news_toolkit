// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../helpers/helpers.dart';

void main() {
  group('PostSmall', () {
    setUpAll(() {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;

      setUpTolerantComparator('test/src/post_small_test.dart');
      setUpMockPathProvider();
    });

    testWidgets('renders correctly without image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          Column(
            children: [
              PostSmall(
                block: PostSmallBlock(
                  id: 'id',
                  category: PostCategory.technology,
                  publishedAt: DateTime(2022, 03, 12),
                  title: 'Nvidia and AMD GPUs are '
                      'returning to shelves and prices '
                      'are finally falling',
                  author: 'Sean Hollister',
                ),
              ),
            ],
          ),
        );
        await expectLater(
          find.byType(PostSmall),
          matchesGoldenFile('post_small_without_image.png'),
        );
      });
    });

    testWidgets('renders correctly with image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpApp(
          Column(
            children: [
              PostSmall(
                block: PostSmallBlock(
                  id: 'id',
                  category: PostCategory.technology,
                  publishedAt: DateTime(2022, 03, 12),
                  title: 'Nvidia and AMD GPUs are '
                      'returning to shelves and prices '
                      'are finally falling',
                  author: 'Sean Hollister',
                  imageUrl:
                      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
                ),
              ),
            ],
          ),
        );
        await expectLater(
          find.byType(PostSmall),
          matchesGoldenFile('post_small_with_image.png'),
        );
      });
    });

    testWidgets('onPressed is called with action when tapped', (tester) async {
      final action = NavigateToArticleAction(articleId: 'id');
      final actions = <BlockAction>[];

      await mockNetworkImages(() async {
        await tester.pumpApp(
          Column(
            children: [
              PostSmall(
                block: PostSmallBlock(
                  id: 'id',
                  category: PostCategory.technology,
                  publishedAt: DateTime(2022, 03, 12),
                  title:
                      'Nvidia and AMD GPUs are returning to shelves and prices '
                      'are finally falling',
                  author: 'Sean Hollister',
                  imageUrl:
                      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
                  action: action,
                ),
                onPressed: actions.add,
              ),
            ],
          ),
        );
      });

      await tester.ensureVisible(find.byType(PostSmall));
      await tester.tap(find.byType(PostSmall));

      expect(actions, equals([action]));
    });
  });
}
