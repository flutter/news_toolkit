// ignore_for_file: prefer_const_constructors
import 'package:{{project_name.snakeCase()}}/newsletter/newsletter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsletterEvent', () {
    const testEmail = 'test@test.com';
    group('EmailChanged', () {
      test('supports value comparisons', () {
        expect(
          EmailChanged(email: testEmail),
          EmailChanged(email: testEmail),
        );
        expect(
          EmailChanged(email: ''),
          isNot(EmailChanged(email: testEmail)),
        );
      });
    });

    group('NewsletterSubscribed', () {
      test('supports value comparisons', () {
        expect(NewsletterSubscribed(), NewsletterSubscribed());
      });
    });
  });
}
