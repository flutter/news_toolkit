// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  group('Image', () {
    testWidgets('renders InlineImage with correct image', (tester) async {
      const block = ImageBlock(imageUrl: 'imageUrl');

      await tester.pumpApp(
        Image(block: block),
      );

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is InlineImage && widget.imageUrl == block.imageUrl,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders ProgressIndicator when loading', (tester) async {
      const block = ImageBlock(imageUrl: 'imageUrl');

      await tester.pumpApp(
        Image(block: block),
      );

      expect(find.byType(ProgressIndicator), findsOneWidget);
    });
  });
}
