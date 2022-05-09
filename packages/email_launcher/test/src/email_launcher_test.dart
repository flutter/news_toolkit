// ignore_for_file: prefer_const_constructors
import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../../test/helpers/mock_url_launcher.dart';

void main() {
  final mock = MockUrlLauncher();

  setUp(() {
    UrlLauncherPlatform.instance = mock;
  });

  group('EmailLauncher', () {
    group('Target platform', () {
      test('is Android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(defaultTargetPlatform, TargetPlatform.android);
        expect(launchEmail(), completes);
        debugDefaultTargetPlatformOverride = null;
      });

      test('is iOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(defaultTargetPlatform, TargetPlatform.iOS);
        debugDefaultTargetPlatformOverride = null;
      });
    });

    group('canLaunch and launchUrl', () {
      test('when target platform is iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(defaultTargetPlatform, TargetPlatform.iOS);
        final url = Uri(scheme: 'message');
        mock
          ..setCanLaunchUrl(url.toString())
          ..setResponse(true);

        final result = await canLaunchUrl(url);
        mock
          ..setLaunchExpectations(
            url: url.toString(),
            useSafariVC: false,
            useWebView: false,
            enableJavaScript: true,
            enableDomStorage: true,
            universalLinksOnly: false,
            headers: <String, String>{},
            webOnlyWindowName: null,
          )
          ..setResponse(true);
        final launch = await launchUrl(url);
        await launchEmail();
        expect(result, isTrue);
        expect(launch, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
