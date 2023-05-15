import 'dart:math' as math;
import 'package:app_ui/app_ui.dart';
import 'package:flutter/rendering.dart';

/// Custom GridDelegate that allows to use [HeaderGridTileLayout].
/// This way, the grid can have the first element as a header.
class CustomMaxCrossAxisDelegate
    extends SliverGridDelegateWithMaxCrossAxisExtent {
  /// Creates a custom delegate that makes grid layouts with tiles
  /// that have a maximum cross-axis extent.
  const CustomMaxCrossAxisDelegate({
    required super.maxCrossAxisExtent,
    super.mainAxisSpacing = 0.0,
    super.crossAxisSpacing = 0.0,
    super.childAspectRatio = 1.0,
    super.mainAxisExtent,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Code copied from [SliverGridDelegateWithMaxCrossAxisExtent].
    var crossAxisCount =
        (constraints.crossAxisExtent / (maxCrossAxisExtent + crossAxisSpacing))
            .ceil();
    // Ensure a minimum count of 1, can be zero and result in an infinite extent
    // below when the window size is 0.
    crossAxisCount = math.max(1, crossAxisCount);
    final double usableCrossAxisExtent = math.max(
      0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );

    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent =
        mainAxisExtent ?? childCrossAxisExtent / childAspectRatio;
    return HeaderGridTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }
}

/// Custom [SliverGridRegularTileLayout] that creates a different
/// [SliverGridGeometry] for the first element of the grid.
class HeaderGridTileLayout extends SliverGridRegularTileLayout {
  /// Creates a custom layout that makes grid layouts with tiles
  /// that have a maximum cross-axis extent.
  const HeaderGridTileLayout({
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  });

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is HeaderGridTileLayout &&
        other.childCrossAxisExtent == childCrossAxisExtent &&
        other.mainAxisStride == mainAxisStride &&
        other.crossAxisStride == crossAxisStride &&
        other.childMainAxisExtent == childMainAxisExtent &&
        other.childCrossAxisExtent == childCrossAxisExtent &&
        other.reverseCrossAxis == reverseCrossAxis;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final result = super.getMinChildIndexForScrollOffset(scrollOffset);
    return (result > 0) ? result - 1 : result;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final isFirstElement = index == 0;

    // We want to handle how to show the first element as a header that occupies
    // the full number of columns.
    if (isFirstElement) {
      return SliverGridGeometry(
        scrollOffset: (index ~/ crossAxisCount) * mainAxisStride,
        crossAxisOffset: (index % crossAxisCount) * crossAxisStride,
        mainAxisExtent: (2 * mainAxisStride) - AppSpacing.md,
        crossAxisExtent: 2 * crossAxisStride - AppSpacing.md,
      );
    } else {
      return SliverGridGeometry(
        scrollOffset: (((index + 1) ~/ crossAxisCount) * mainAxisStride) +
            childMainAxisExtent,
        crossAxisOffset: ((index + 1) % crossAxisCount) * crossAxisStride,
        mainAxisExtent: mainAxisStride,
        crossAxisExtent: childCrossAxisExtent,
      );
    }
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    // Since the first element is taking up twice the
    // width and height of the other grid elements,
    // for computing max scroll offset it can be assumed
    // as if there was 3 more children on the grid, so
    // every child after that position must move below,
    // affecting the max scroll offset.
    return super.computeMaxScrollOffset(childCount + 3);
  }
}
