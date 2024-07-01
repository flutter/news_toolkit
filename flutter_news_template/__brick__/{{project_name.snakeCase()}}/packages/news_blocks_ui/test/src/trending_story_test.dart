// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../helpers/helpers.dart';

void main() {
  group('TrendingStory', () {
    setUpAll(() {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;

      setUpTolerantComparator('test/src/trending_story_test.dart');
      setUpMockPathProvider();
    });

    testWidgets('renders correctly', (tester) async {
      await mockNetworkImages(() async {
        final widget = TrendingStory(
          title: 'TRENDING',
          block: TrendingStoryBlock(
            content: PostSmallBlock(
              id: 'id',
              category: PostCategory.technology,
              author: 'author',
              publishedAt: DateTime(2022, 3, 11),
              imageUrl: 'imageUrl',
              title: 'title',
            ),
          ),
        );

        await tester.pumpApp(widget);

        await expectLater(
          find.byType(TrendingStory),
          matchesGoldenFile('trending_story.png'),
        );
      });
    });
  });
}
