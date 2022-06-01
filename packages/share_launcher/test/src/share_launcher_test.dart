// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:share_launcher/share_launcher.dart';

void main() {
  group('ShareLauncher', () {
    test('calls share', () async {
      var called = false;

      TestWidgetsFlutterBinding.ensureInitialized();
      await ShareLauncher.share(text: 'text', url: 'url')
          .whenComplete(() => called = true);

      expect(called, isTrue);
    });
  });
}
