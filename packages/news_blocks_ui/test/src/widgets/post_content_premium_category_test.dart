// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostContentPremiumCategory', () {
    testWidgets('renders premium text in uppercase', (tester) async {
      final testPostContentPremiumCategory = PostContentPremiumCategory(
        premiumText: 'premiumText',
        isVideoContent: false,
      );

      await tester.pumpContentThemedApp(testPostContentPremiumCategory);

      expect(
        find.text(testPostContentPremiumCategory.premiumText.toUpperCase()),
        findsOneWidget,
      );
    });
  });
}
