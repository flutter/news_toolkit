// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('StickyAd', () {
    testWidgets(
        'renders StickyAdContainer '
        'with anchoredAdaptive BannerAdContent', (tester) async {
      await tester.pumpApp(StickyAd());

      expect(
        find.descendant(
          of: find.byType(StickyAdContainer),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is BannerAdContent &&
                widget.size == BannerAdSize.anchoredAdaptive &&
                widget.showProgressIndicator == false,
          ),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders StickyAdCloseIconBackground and StickyAdCloseIcon '
        'when ad is loaded', (tester) async {
      await tester.pumpApp(StickyAd());

      expect(find.byType(StickyAdCloseIconBackground), findsNothing);
      expect(find.byType(StickyAdCloseIcon), findsNothing);

      final bannerAdContent =
          tester.widget<BannerAdContent>(find.byType(BannerAdContent));
      bannerAdContent.onAdLoaded?.call();
      await tester.pump();

      expect(find.byType(StickyAdCloseIconBackground), findsOneWidget);
      expect(find.byType(StickyAdCloseIcon), findsOneWidget);
    });

    testWidgets('hides ad when closed icon is tapped', (tester) async {
      await tester.pumpApp(StickyAd());

      final bannerAdContent =
          tester.widget<BannerAdContent>(find.byType(BannerAdContent));
      bannerAdContent.onAdLoaded?.call();
      await tester.pump();

      await tester.ensureVisible(find.byType(StickyAdCloseIcon));
      await tester.tap(find.byType(StickyAdCloseIcon));
      await tester.pump();

      expect(find.byType(BannerAdContent), findsNothing);
      expect(find.byType(StickyAdCloseIconBackground), findsNothing);
      expect(find.byType(StickyAdCloseIcon), findsNothing);
    });
  });
}
