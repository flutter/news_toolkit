import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostFooter', () {
    setUpAll(setUpTolerantComparator);

    testWidgets('renders correctly without author', (tester) async {
      await tester.pumpApp(
        PostFooter(
          publishedAt: DateTime(2022, 5, 9),
        ),
      );

      await expectLater(
        find.byType(PostFooter),
        matchesGoldenFile('post_footer_without_author.png'),
      );
    });

    testWidgets('renders correctly with author', (tester) async {
      await tester.pumpApp(
        PostFooter(
          publishedAt: DateTime(2022, 5, 9),
          author: 'Author',
        ),
      );

      await expectLater(
        find.byType(PostFooter),
        matchesGoldenFile('post_footer_with_author.png'),
      );
    });

    testWidgets('onShare is called when tapped', (tester) async {
      var onShareTapped = 0;
      await tester.pumpApp(
        PostFooter(
          publishedAt: DateTime(2022, 5, 9),
          onShare: () => onShareTapped++,
        ),
      );

      await tester.tap(find.byType(IconButton));

      expect(onShareTapped, equals(1));
    });
  });
}
