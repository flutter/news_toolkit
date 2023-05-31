// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('PostGrid', () {
    final postGridTileBlock = PostGridTileBlock(
      id: '842e3193-86d2-4069-a7e6-f769faa6f970',
      category: PostCategory.science,
      author: 'SciTechDaily',
      publishedAt: DateTime(2022, 5, 5),
      imageUrl:
          'https://scitechdaily.com/images/Qubit-Platform-Single-Electron-on-Solid-Neon.jpg',
      title: 'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
          'Revolutionize Quantum Computing',
      action: NavigateToArticleAction(
        articleId: '842e3193-86d2-4069-a7e6-f769faa6f970',
      ),
    );

    testWidgets('renders correctly 5 PostGridTiles', (tester) async {
      final gridGroupBlock = PostGridGroupBlock(
        category: PostCategory.science,
        tiles: List.generate(5, (index) => postGridTileBlock),
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          CustomScrollView(
            slivers: [
              PostGrid(
                gridGroupBlock: gridGroupBlock,
                premiumText: 'Premium',
              ),
            ],
          ),
        ),
      );

      expect(find.byType(PostLarge), findsOneWidget);
      await tester.ensureVisible(find.byType(PostMedium).last);

      await tester.pumpAndSettle();

      expect(find.byType(PostMedium), findsNWidgets(4));
    });

    testWidgets('renders correctly 1 PostGridTile', (tester) async {
      final gridGroupBlock = PostGridGroupBlock(
        category: PostCategory.science,
        tiles: [postGridTileBlock],
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          CustomScrollView(
            slivers: [
              PostGrid(gridGroupBlock: gridGroupBlock, premiumText: 'Premium'),
            ],
          ),
        ),
      );

      expect(find.byType(PostGrid), findsOneWidget);
      expect(find.byType(PostLarge), findsOneWidget);
      expect(find.byType(PostMedium), findsNothing);
    });

    testWidgets('handles empty tiles list', (tester) async {
      final gridGroupBlock = PostGridGroupBlock(
        category: PostCategory.science,
        tiles: [],
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          CustomScrollView(
            slivers: [
              PostGrid(gridGroupBlock: gridGroupBlock, premiumText: 'Premium'),
            ],
          ),
        ),
      );

      expect(find.byType(SliverToBoxAdapter), findsNothing);
      expect(find.byType(PostLarge), findsNothing);
      expect(find.byType(PostMedium), findsNothing);
    });
  });
}
