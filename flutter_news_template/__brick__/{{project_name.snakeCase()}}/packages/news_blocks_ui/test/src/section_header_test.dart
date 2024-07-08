import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('SectionHeader', () {
    setUpAll(
      () => setUpTolerantComparator('test/src/section_header_test.dart'),
    );

    testWidgets('renders correctly without action', (tester) async {
      const widget = Center(
        child: SectionHeader(
          block: SectionHeaderBlock(title: 'example'),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(SectionHeader),
        matchesGoldenFile('section_header_without_action.png'),
      );
    });

    testWidgets('renders correctly with action', (tester) async {
      const widget = Center(
        child: SectionHeader(
          block: SectionHeaderBlock(
            title: 'example',
            action: NavigateToFeedCategoryAction(category: Category.top),
          ),
        ),
      );

      await tester.pumpApp(widget);

      await expectLater(
        find.byType(SectionHeader),
        matchesGoldenFile('section_header_with_action.png'),
      );
    });

    testWidgets('onPressed is called with action on tap', (tester) async {
      final actions = <BlockAction>[];
      const action = NavigateToFeedCategoryAction(category: Category.top);

      final widget = Center(
        child: SectionHeader(
          block: const SectionHeaderBlock(
            title: 'example',
            action: action,
          ),
          onPressed: actions.add,
        ),
      );

      await tester.pumpApp(widget);

      await tester.tap(find.byType(IconButton));

      expect(actions, equals([action]));
    });
  });
}
