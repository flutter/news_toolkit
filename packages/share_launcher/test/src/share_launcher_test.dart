// ignore_for_file: prefer_const_constructors
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_launcher/share_launcher.dart';

void main() {
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
    });
  });
}
