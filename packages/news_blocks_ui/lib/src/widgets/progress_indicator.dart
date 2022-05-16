import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template progress_indicator}
/// The reusable progress indicator of post images and videos.
/// {@endtemplate}
class ProgressIndicator extends StatelessWidget {
  /// {@macro progress_indicator}
  const ProgressIndicator({
    super.key,
    this.progress,
  });

  /// The current progress of this indicator (between 0 and 1).
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.gainsboro,
      child: Center(
        child: CircularProgressIndicator(value: progress),
      ),
    );
  }
}
