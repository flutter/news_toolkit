// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../helpers/helpers.dart';

void main() {
  const category = PostCategory.technology;
  const videoUrl =
      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg='
      '/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset'
      '/file/22049166/shollister_201117_4303_0003.0.jpg';
  const title = 'Nvidia and AMD GPUs are returning to shelves '
      'and prices are finally falling';

  group('VideoIntroduction', () {
    setUpAll(
      () {
        final fakeVideoPlayerPlatform = FakeVideoPlayerPlatform();
        VideoPlayerPlatform.instance = fakeVideoPlayerPlatform;
        setUpTolerantComparator(
          'test/src/video_introduction_test.dart',
        );
      },
    );

    testWidgets('renders correctly', (tester) async {
      final technologyVideoIntroduction = VideoIntroductionBlock(
        category: category,
        videoUrl: videoUrl,
        title: title,
      );

      await mockNetworkImages(
        () async => tester.pumpContentThemedApp(
          SingleChildScrollView(
            child: Column(
              children: [
                VideoIntroduction(block: technologyVideoIntroduction),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(InlineVideo), findsOneWidget);
      expect(find.byType(PostContent), findsOneWidget);
    });
  });
}
