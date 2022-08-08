// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/banner_ad.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../helpers/helpers.dart';

void main() {
  group('BannerAd', () {
    testWidgets('renders BannerAdContainer', (tester) async {
      const block = BannerAdBlock(size: BannerAdSize.normal);

      await tester.pumpApp(
        BannerAd(
          block: block,
          adFailedToLoadTitle: 'adFailedToLoadTitle',
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is BannerAdContainer && widget.size == block.size,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders BannerAdContent', (tester) async {
      const block = BannerAdBlock(size: BannerAdSize.normal);

      await tester.pumpApp(
        BannerAd(
          block: block,
          adFailedToLoadTitle: 'adFailedToLoadTitle',
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is BannerAdContent && widget.size == block.size,
        ),
        findsOneWidget,
      );
    });
  });
}
