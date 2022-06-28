// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SlideshowCategory', () {
    testWidgets('renders slideshow text in uppercase', (tester) async {
      final slideshowCategory = SlideshowCategory(
        slideshowText: 'slideshowText',
      );

      await tester.pumpContentThemedApp(slideshowCategory);

      expect(
        find.text(slideshowCategory.slideshowText.toUpperCase()),
        findsOneWidget,
      );
    });
  });
}
