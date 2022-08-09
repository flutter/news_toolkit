// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  const imageUrl =
      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg='
      '/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset'
      '/file/22049166/shollister_201117_4303_0003.0.jpg';

  group('SlideshowIntroduction', () {
    testWidgets('renders title', (tester) async {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: imageUrl,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          SingleChildScrollView(
            child: Column(
              children: [
                SlideshowIntroduction(
                  block: block,
                  slideshowText: 'slideshowText',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(block.title), findsOneWidget);
    });

    testWidgets('renders SlideshowCategory', (tester) async {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: imageUrl,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          SingleChildScrollView(
            child: Column(
              children: [
                SlideshowIntroduction(
                  block: block,
                  slideshowText: 'slideshowText',
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is SlideshowCategory && widget.isIntroduction == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders cover image', (tester) async {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: imageUrl,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          SingleChildScrollView(
            child: Column(
              children: [
                SlideshowIntroduction(
                  block: block,
                  slideshowText: 'slideshowText',
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostLargeImage && widget.imageUrl == imageUrl,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'onPressed is called with action when tapped',
      (tester) async {
        final action = NavigateToArticleAction(articleId: 'articleId');
        final actions = <BlockAction>[];

        final block = SlideshowIntroductionBlock(
          title: 'title',
          coverImageUrl: imageUrl,
          action: action,
        );

        await mockNetworkImages(
          () async => tester.pumpContentThemedApp(
            SingleChildScrollView(
              child: Column(
                children: [
                  SlideshowIntroduction(
                    block: block,
                    slideshowText: 'slideshowText',
                    onPressed: actions.add,
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.ensureVisible(find.byType(SlideshowIntroduction));
        await tester.tap(find.byType(SlideshowIntroduction));
        await tester.pump();

        expect(actions, equals([action]));
      },
    );
  });
}
