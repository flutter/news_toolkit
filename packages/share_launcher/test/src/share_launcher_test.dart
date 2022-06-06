// ignore_for_file: prefer_const_constructors
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_launcher/share_launcher.dart';

void main() {
  late ShareLauncher shareLauncher;

  setUp(() {
    shareLauncher = ShareLauncher();
  });

  group('ShareLauncher', () {
    test('calls share with text', () async {
      var called = false;

      TestWidgetsFlutterBinding.ensureInitialized();

      MethodChannel('dev.fluttercommunity.plus/share')
          .setMockMethodCallHandler((_) async => called = true);

      await shareLauncher.share(text: 'text');

      expect(called, isTrue);
    });
  });
}
