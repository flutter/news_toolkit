import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};

  context.logger.info('POST GEN clean up.. ${vars['include_ads']}');
  bool removeAds = vars['include_ads'].toString().toLowerCase() == 'false';

  if (removeAds) {
    // remove lib/ads & test/ads, packages/ads_consent_client.
    // clean up NewsBlocs remove banner ad refs
    context.logger.info('POST GEN removing dead code..');
    try {
      String widgetPath = 'packages/news_blocks_ui/lib/src/widgets';
      String widgetTestPath = 'packages/news_blocks_ui/test/src/widgets';

      const bannerWidget = [
        'banner_ad_container',
        'banner_ad_content',
      ];

      const bannerAd = [
        'packages/news_blocks_ui/lib/src/banner_ad.dart',
        'packages/news_blocks_ui/test/src/banner_ad_test.dart'
      ];

      const dirPaths = [
        'lib/ads',
        'packages/ads_consent_client',
      ];
      var paths = [
        ...dirPaths,
        ...bannerAd,
        ...(bannerWidget.map((b) => '$widgetPath/$b.dart')),
        ...(bannerWidget.map((b) => '$widgetTestPath/${b}_test.dart')),
      ];

      paths.map((path) => File(path).deleteSync(recursive: true));

      context.logger.info('POST GEN clean up complete');
    } on Exception catch (e) {
      context.logger.err(e.toString());
    }
  }
}
