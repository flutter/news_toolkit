import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

void main() {
  group('DividerHorizontal', () {
    testWidgets('renders correctly', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: DividerHorizontal(
              block: DividerHorizontalBlock(),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(DividerHorizontal),
        matchesGoldenFile('divider_horizontal.png'),
      );
    });
  });
}
