// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_email_client/open_email_client.dart';
import 'package:open_email_client/src/mock_url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  final mock = MockUrlLauncher();

  setUp(() {
    UrlLauncherPlatform.instance = mock;
  });

  group('OpenEmailClient', () {
    test('can be instantiated', () {
      expect(OpenEmailClient(), isNotNull);
    });

    test('target platform is Android', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(defaultTargetPlatform, TargetPlatform.android);
      expect(OpenEmailClient().openEmailApp(), completes);
      debugDefaultTargetPlatformOverride = null;
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
        await OpenEmailClient().openEmailApp();
        expect(result, isTrue);
        expect(launch, isTrue);
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
