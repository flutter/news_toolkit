// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);
  group('PostLarge', () {
    final _technologyPostLarge = PostLargeBlock(
      id: '499305f6-5096-4051-afda-824dcfc7df23',
      category: PostCategory.technology,
      author: 'Sean Hollister',
      publishedAt: DateTime(2022, 3, 9),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      title: 'Nvidia and AMD GPUs are returning to shelves '
          'and prices are finally falling',
    );

    testWidgets('renders correctly non-premium', (tester) async {
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: ContentThemeOverrideBuilder(
              builder: (context) => PostLarge(
                block: _technologyPostLarge,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(PostLarge),
        matchesGoldenFile('post_large_non_premium.png'),
      );
    });

    testWidgets('renders correctly premium', (tester) async {
      final premiumBlock = PostLargeBlock.fromJson(
        _technologyPostLarge.toJson()..['isPremium'] = true,
      );

      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: ContentThemeOverrideBuilder(
              builder: (context) => PostLarge(
                block: premiumBlock,
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(PostLarge),
        matchesGoldenFile('post_large_premium.png'),
      );
    });
  });
}
