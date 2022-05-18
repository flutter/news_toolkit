// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostContent', () {
    testWidgets('renders correctly', (tester) async {
      final testPostContent = PostContent(
        title: 'title',
        premiumText: 'premiumText',
      );

      await tester.pumpContentThemedApp(testPostContent);

      expect(
        find.byType(PostFooter),
        findsOneWidget,
      );
    });
  });
}
