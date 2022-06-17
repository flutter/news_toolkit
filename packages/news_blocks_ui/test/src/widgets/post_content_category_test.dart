// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostContentCategory', () {
    testWidgets('renders category name in uppercase', (tester) async {
      final testPostContentCategory = PostContentCategory(
        categoryName: 'Test',
        isContentOverlaid: false,
        isVideoContent: false,
      );

      await tester.pumpContentThemedApp(testPostContentCategory);

      expect(
        find.text(testPostContentCategory.categoryName.toUpperCase()),
        findsOneWidget,
      );
    });
  });
}
