import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders correctly without action', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: SectionHeader(
              block: SectionHeaderBlock(title: 'example'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(SectionHeader),
        matchesGoldenFile('section_header_without_action.png'),
      );
    });

    testWidgets('renders correctly with action', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: SectionHeader(
              block: SectionHeaderBlock(
                title: 'example',
                action: BlockAction(type: BlockActionType.navigation),
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      expect(
        find.byType(SectionHeader),
        matchesGoldenFile('section_header_with_action.png'),
      );
    });

    testWidgets('onPressed is called with action on tap', (tester) async {
      final actions = <BlockAction>[];
      const action = BlockAction(type: BlockActionType.navigation);
      final widget = MaterialApp(
        home: Scaffold(
          body: Center(
            child: SectionHeader(
              block: const SectionHeaderBlock(
                title: 'example',
                action: action,
              ),
              onPressed: actions.add,
            ),
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.tap(find.byType(IconButton));

      expect(actions, equals([action]));
    });
  });
}
