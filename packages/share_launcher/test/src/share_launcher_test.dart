// ignore_for_file: prefer_const_constructors
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
  });
}
