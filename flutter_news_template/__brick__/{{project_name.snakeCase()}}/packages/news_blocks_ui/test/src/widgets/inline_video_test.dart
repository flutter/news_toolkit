// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../helpers/helpers.dart';

void main() {
  group('InlineVideo', () {
    setUp(
      () {
        final fakeVideoPlayerPlatform = FakeVideoPlayerPlatform();
        VideoPlayerPlatform.instance = fakeVideoPlayerPlatform;
      },
    );

    testWidgets('renders progressIndicator when loading', (tester) async {
      const progressIndicatorKey = Key('__progress_indicator__');
      final controller = FakeVideoPlayerController();

      await tester.pumpApp(
        InlineVideo(
          videoUrl: 'videoUrl',
          progressIndicator: ProgressIndicator(key: progressIndicatorKey),
          videoPlayerControllerBuilder: (_) => controller,
        ),
      );

      expect(find.byKey(progressIndicatorKey), findsOneWidget);
    });

    testWidgets('renders VideoPlayer when initialized', (tester) async {
      final controller = FakeVideoPlayerController();

      controller.value = controller.value.copyWith(
        isInitialized: true,
        size: Size(100, 100),
      );

      await tester.pumpApp(
        InlineVideo(
          videoUrl: 'videoUrl',
          progressIndicator: ProgressIndicator(),
          videoPlayerControllerBuilder: (_) => controller,
        ),
      );

      expect(find.byType(VideoPlayer), findsOneWidget);
    });

    testWidgets('renders VideoPlayer when initialized', (tester) async {
      final controller = FakeVideoPlayerController();

      controller.value = controller.value.copyWith(
        isInitialized: true,
        size: Size(100, 100),
      );

      await tester.pumpApp(
        InlineVideo(
          videoUrl: 'videoUrl',
          progressIndicator: ProgressIndicator(),
          videoPlayerControllerBuilder: (_) => controller,
        ),
      );

      expect(find.byType(VideoPlayer), findsOneWidget);
    });

    testWidgets(
        'plays video when tapped '
        'and video is not playing', (tester) async {
      final controller = FakeVideoPlayerController();

      controller.value = controller.value.copyWith(
        isInitialized: true,
        size: Size(100, 100),
      );

      await tester.pumpApp(
        InlineVideo(
          videoUrl: 'videoUrl',
          progressIndicator: ProgressIndicator(),
          videoPlayerControllerBuilder: (_) => controller,
        ),
      );

      await tester.tap(find.byKey(Key('inlineVideo_gestureDetector')));
      await tester.pump();
      expect(controller.playCalled, equals(1));
      expect(controller.pauseCalled, equals(0));
    });

    testWidgets(
        'pauses video when tapped '
        'and video is playing', (tester) async {
      final controller = FakeVideoPlayerController();

      controller.value = controller.value.copyWith(
        isInitialized: true,
        size: Size(100, 100),
      );

      await tester.pumpApp(
        InlineVideo(
          videoUrl: 'videoUrl',
          progressIndicator: ProgressIndicator(),
          videoPlayerControllerBuilder: (_) => controller,
        ),
      );

      controller
        ..textureId = 123
        ..value = controller.value.copyWith(isPlaying: true);

      await tester.pump();

      await tester.tap(find.byKey(Key('inlineVideo_gestureDetector')));
      await tester.pump();
      expect(controller.playCalled, equals(0));
      expect(controller.pauseCalled, equals(1));
    });

    testWidgets('builds VideoPlayerController with videoUrl', (tester) async {
      const videoUrl = 'videoUrl';
      late String capturedVideoUrl;

      await tester.pumpApp(
        InlineVideo(
          videoUrl: videoUrl,
          progressIndicator: ProgressIndicator(),
          videoPlayerControllerBuilder: (url) {
            capturedVideoUrl = url.toString();
            return FakeVideoPlayerController();
          },
        ),
      );

      expect(capturedVideoUrl, equals(videoUrl));
    });
  });
}

class FakeVideoPlayerController extends ValueNotifier<VideoPlayerValue>
    implements VideoPlayerController {
  FakeVideoPlayerController()
      : super(VideoPlayerValue(duration: Duration.zero));

  int playCalled = 0;
  int pauseCalled = 0;

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  int textureId = VideoPlayerController.kUninitializedTextureId;

  @override
  String get dataSource => '';

  @override
  Map<String, String> get httpHeaders => <String, String>{};

  @override
  DataSourceType get dataSourceType => DataSourceType.file;

  @override
  String get package => '';

  @override
  Future<Duration> get position async => value.position;

  @override
  Future<void> seekTo(Duration moment) async {}

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> setPlaybackSpeed(double speed) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<void> pause() async => pauseCalled++;

  @override
  Future<void> play() async => playCalled++;

  @override
  Future<void> setLooping(bool looping) async {}

  @override
  VideoFormat? get formatHint => null;

  @override
  Future<ClosedCaptionFile> get closedCaptionFile => _loadClosedCaption();

  @override
  VideoPlayerOptions? get videoPlayerOptions => null;

  @override
  void setCaptionOffset(Duration delay) {}

  @override
  Future<void> setClosedCaptionFile(
    Future<ClosedCaptionFile>? closedCaptionFile,
  ) async {}
}

Future<ClosedCaptionFile> _loadClosedCaption() async =>
    _FakeClosedCaptionFile();

class _FakeClosedCaptionFile extends ClosedCaptionFile {
  @override
  List<Caption> get captions {
    return <Caption>[
      const Caption(
        text: 'one',
        number: 0,
        start: Duration(milliseconds: 100),
        end: Duration(milliseconds: 200),
      ),
      const Caption(
        text: 'two',
        number: 1,
        start: Duration(milliseconds: 300),
        end: Duration(milliseconds: 400),
      ),
    ];
  }
}
