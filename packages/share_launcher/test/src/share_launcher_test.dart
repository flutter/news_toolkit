// ignore_for_file: prefer_const_constructors
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_launcher/share_launcher.dart';

void main() {
  group('ShareLauncher', () {
    test('calls share with text', () async {
      var called = false;

      TestWidgetsFlutterBinding.ensureInitialized();

      MethodChannel('dev.fluttercommunity.plus/share')
          .setMockMethodCallHandler((call) async => called = true);

      await ShareLauncher.share(text: 'text');

      expect(called, isTrue);
    });
  });
}
