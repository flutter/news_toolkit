import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/generated/generated.dart';
import 'package:video_player/video_player.dart';

/// Signature for [VideoPlayerController] builder.
typedef VideoPlayerControllerBuilder = VideoPlayerController Function(
  Uri videoUrl,
);

/// {@template inline_video}
/// A reusable video widget displayed inline with the content.
/// {@endtemplate}
class InlineVideo extends StatefulWidget {
  /// {@macro inline_video}
  const InlineVideo({
    required this.videoUrl,
    required this.progressIndicator,
    this.videoPlayerControllerBuilder = VideoPlayerController.networkUrl,
    super.key,
  });

  /// The aspect ratio of this video.
  static const _aspectRatio = 3 / 2;

  /// The url of this video.
  final String videoUrl;

  /// Widget displayed while the target [videoUrl] is loading.
  final Widget progressIndicator;

  /// The builder of [VideoPlayerController] used in this video.
  final VideoPlayerControllerBuilder videoPlayerControllerBuilder;

  @override
  State<InlineVideo> createState() => _InlineVideoState();
}

class _InlineVideoState extends State<InlineVideo> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.videoPlayerControllerBuilder(
      Uri.parse(widget.videoUrl),
    )
      ..addListener(_onVideoUpdated)
      ..initialize().then((_) {
        // Ensure the first frame of the video is shown
        // after the video is initialized.
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller
      ..removeListener(_onVideoUpdated)
      ..dispose();
  }

  void _onVideoUpdated() {
    if (!mounted || _isPlaying == _controller.value.isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: InlineVideo._aspectRatio,
      child: _controller.value.isInitialized
          ? GestureDetector(
              key: const Key('inlineVideo_gestureDetector'),
              onTap: _isPlaying ? _controller.pause : _controller.play,
              child: ClipRRect(
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
                    Center(
                      child: Visibility(
                        visible: !_isPlaying,
                        child: Assets.icons.playIcon.svg(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : widget.progressIndicator,
    );
  }
}
