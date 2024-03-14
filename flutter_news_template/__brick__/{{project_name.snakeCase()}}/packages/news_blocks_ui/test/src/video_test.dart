// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../helpers/helpers.dart';

void main() {
  group('Video', () {
    setUp(
      () {
        final fakeVideoPlayerPlatform = FakeVideoPlayerPlatform();
        VideoPlayerPlatform.instance = fakeVideoPlayerPlatform;
      },
    );

    testWidgets('renders InlineVideo with correct video', (tester) async {
      const block = VideoBlock(videoUrl: 'videoUrl');

      await tester.pumpApp(
        Video(block: block),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InlineVideo && widget.videoUrl == block.videoUrl,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders ProgressIndicator when loading', (tester) async {
      const block = VideoBlock(videoUrl: 'videoUrl');

      await tester.pumpWidget(
        Video(block: block),
      );

      expect(
        find.byType(ProgressIndicator, skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
