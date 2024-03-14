// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/sliver_grid_custom_delegate.dart';

void main() {
  group('SliverGridCustomDelegate', () {
    testWidgets('getLayout when crossAxisCount is <=1', (tester) async {
      const childAspectRatio = 3 / 2;
      const childCrossAxisExtent = 343.0;
      const childMainAxisExtent = childCrossAxisExtent * 1 / childAspectRatio;

      final customMaxCrossAxisDelegate = CustomMaxCrossAxisDelegate(
        maxCrossAxisExtent: 400,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: childAspectRatio,
      );

      final customDelegate = customMaxCrossAxisDelegate.getLayout(
        SliverConstraints(
          axisDirection: AxisDirection.down,
          growthDirection: GrowthDirection.forward,
          userScrollDirection: ScrollDirection.idle,
          scrollOffset: 0,
          precedingScrollExtent: 1525,
          overlap: 0,
          remainingPaintExtent: 0,
          crossAxisExtent: childCrossAxisExtent,
          crossAxisDirection: AxisDirection.right,
          viewportMainAxisExtent: 505,
          remainingCacheExtent: 0,
          cacheOrigin: 0,
        ),
      );

      final headerDelegate = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: childMainAxisExtent + AppSpacing.md,
        crossAxisStride: childCrossAxisExtent + AppSpacing.md,
        childMainAxisExtent: childMainAxisExtent,
        childCrossAxisExtent: childCrossAxisExtent,
        reverseCrossAxis: false,
      );

      expect(customDelegate, headerDelegate);
    });

    testWidgets('getLayout when crossAxisCount is >1', (tester) async {
      const childAspectRatio = 3 / 2;
      const crossAxisExtent = 400.0;
      const maxCrossAxisExtent = 200.0;
      const childCrossAxisExtent = maxCrossAxisExtent - AppSpacing.xs / 2;
      const childMainAxisExtent = childCrossAxisExtent * 1 / childAspectRatio;
      final customMaxCrossAxisDelegate = CustomMaxCrossAxisDelegate(
        maxCrossAxisExtent: maxCrossAxisExtent,
        mainAxisSpacing: AppSpacing.xs,
        crossAxisSpacing: AppSpacing.xs,
        childAspectRatio: 3 / 2,
      );

      final customDelegate = customMaxCrossAxisDelegate.getLayout(
        SliverConstraints(
          axisDirection: AxisDirection.down,
          growthDirection: GrowthDirection.forward,
          userScrollDirection: ScrollDirection.idle,
          scrollOffset: 0,
          precedingScrollExtent: 1525,
          overlap: 0,
          remainingPaintExtent: 0,
          crossAxisExtent: crossAxisExtent,
          crossAxisDirection: AxisDirection.right,
          viewportMainAxisExtent: 505,
          remainingCacheExtent: 0,
          cacheOrigin: 0,
        ),
      );

      final headerDelegate = HeaderGridTileLayout(
        crossAxisCount: (crossAxisExtent / maxCrossAxisExtent).ceil(),
        mainAxisStride: childMainAxisExtent + AppSpacing.xs,
        crossAxisStride: childCrossAxisExtent + AppSpacing.xs,
        childMainAxisExtent: childMainAxisExtent,
        childCrossAxisExtent: childCrossAxisExtent,
        reverseCrossAxis: false,
      );

      expect(customDelegate, headerDelegate);
    });
  });
}
