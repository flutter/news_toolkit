// ignore_for_file: prefer_const_constructors

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/sliver_grid_custom_delegate.dart';

void main() {
  group('HeaderGridTileLayout', () {
    testWidgets(
        'getMinChildIndexForScrollOffset when '
        'super.getMinChildIndexForScrollOffset is 0', (tester) async {
      final headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final result = headerTileLayout.getMinChildIndexForScrollOffset(0);

      expect(result, 0);
    });

    testWidgets(
        'getMinChildIndexForScrollOffset when '
        'super.getMinChildIndexForScrollOffset is greater than 0',
        (tester) async {
      final headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final result = headerTileLayout.getMinChildIndexForScrollOffset(100);

      expect(result, 6);
    });

    testWidgets(
        'getGeometryForChildIndex when index is equal to 0 (first element) ',
        (tester) async {
      final headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final geometry = headerTileLayout.getGeometryForChildIndex(0);

      final expectedGeometry = SliverGridGeometry(
        scrollOffset: 0,
        crossAxisOffset: 0,
        mainAxisExtent: 16,
        crossAxisExtent: 18,
      );

      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
      expect(geometry.scrollOffset, expectedGeometry.scrollOffset);
      expect(geometry.mainAxisExtent, expectedGeometry.mainAxisExtent);
      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
    });

    testWidgets('getGeometryForChildIndex when index is not equal to 0',
        (tester) async {
      final headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final geometry = headerTileLayout.getGeometryForChildIndex(2);

      final expectedGeometry = SliverGridGeometry(
        scrollOffset: 44,
        crossAxisOffset: 0,
        mainAxisExtent: 14,
        crossAxisExtent: 3,
      );

      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
      expect(geometry.scrollOffset, expectedGeometry.scrollOffset);
      expect(geometry.mainAxisExtent, expectedGeometry.mainAxisExtent);
      expect(geometry.crossAxisExtent, expectedGeometry.crossAxisExtent);
    });
    testWidgets('computeMaxScrollOffset', (tester) async {
      final headerTileLayout = HeaderGridTileLayout(
        crossAxisCount: 1,
        mainAxisStride: 14,
        crossAxisStride: 15,
        childMainAxisExtent: 2,
        childCrossAxisExtent: 3,
        reverseCrossAxis: false,
      );

      final maxScrollOffset = headerTileLayout.computeMaxScrollOffset(2);

      expect(maxScrollOffset, 58);
    });
  });
}
