// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_launcher/share_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  setUpAll(() {
    UrlLauncherPlatform.instance = MockUrlLauncher();
  });

  group('ShareFailure', () {
    test('supports value comparison', () {
      final shareFailure1 = ShareFailure('error');
      final shareFailure2 = ShareFailure('error');
      expect(shareFailure1, equals(shareFailure2));
    });
  });

  group('ShareLauncher', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    test('calls share with text', () async {
      var called = false;

      final shareLauncher = ShareLauncher(
        shareProvider: (String text) async {
          called = true;
          expect(text, equals('text'));
        },
      );

      await shareLauncher.share(text: 'text');

      expect(called, isTrue);
    });

    test('throws ShareFailure when shareLauncher throws', () async {
      final shareLauncher = ShareLauncher(
        shareProvider: (String text) => throw Exception(),
      );

      expect(shareLauncher.share(text: 'text'), throwsA(isA<ShareFailure>()));
    });

    test(
        'calls default ShareProvider with text '
        'when shareProvider not provided '
        'on iOS', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      TestWidgetsFlutterBinding.ensureInitialized();
      var called = false;

      MethodChannel('dev.fluttercommunity.plus/share')
          .setMockMethodCallHandler((_) async => called = true);

      await ShareLauncher().share(text: 'text');

      expect(called, isTrue);

      debugDefaultTargetPlatformOverride = null;
    });

    test(
        'calls default ShareProvider with text '
        'when shareProvider not provided '
        'on android', () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      TestWidgetsFlutterBinding.ensureInitialized();
      var called = false;

      MethodChannel('dev.fluttercommunity.plus/share')
          .setMockMethodCallHandler((_) async => called = true);

      await ShareLauncher().share(text: 'text');

      expect(called, isTrue);

      debugDefaultTargetPlatformOverride = null;
    });
  });
}
