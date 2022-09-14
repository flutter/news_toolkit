import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final vars = {...context.vars};

  final project_name = vars['project_name'];

  context.logger.info('POST GEN clean up.. ~${vars['project_name']}~');
  bool removeAds = vars['include_ads'].toString().toLowerCase() == 'false';

  if (removeAds) {
    // remove lib/ads & test/ads, packages/ads_consent_client.
    // clean up NewsBlocs remove banner ad refs
    context.logger.info('POST GEN removing dead code..');
    try {
      String widgetPath =
          '${project_name}/packages/news_blocks_ui/lib/src/widgets';
      String widgetTestPath =
          '${project_name}/packages/news_blocks_ui/test/src/widgets';

      const bannerWidget = [
        'banner_ad_container',
        'banner_ad_content',
      ];

      final bannerAd = [
        '${project_name}/packages/news_blocks_ui/lib/src/banner_ad.dart',
        '${project_name}/packages/news_blocks_ui/test/src/banner_ad_test.dart'
      ];

      final dirPaths = [
        '${project_name}/lib/ads',
        '${project_name}/test/ads',
        '${project_name}/packages/ads_consent_client',
      ];
      var paths = [
        ...dirPaths,
        ...bannerAd,
        ...(bannerWidget.map((b) => '$widgetPath/$b.dart')),
        ...(bannerWidget.map((b) => '$widgetTestPath/${b}_test.dart')),
      ];

      paths.forEach((path) {
        context.logger.info('Deleting $path');
        File(path).deleteSync(recursive: true);
      });

      context.logger.info('POST GEN clean up done');
    } on Exception catch (e) {
      context.logger.err(e.toString());
    }
  }
  context.logger.info('POST GEN complete!');
}
