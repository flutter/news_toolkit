// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/reset_password/reset_password.dart';

void main() {
  group('ResetPasswordEvent', () {
    group('ResetPasswordEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          ResetPasswordEmailChanged('test@gmail.com'),
          ResetPasswordEmailChanged('test@gmail.com'),
        );
        expect(
          ResetPasswordEmailChanged(''),
          isNot(ResetPasswordEmailChanged('test@gmail.com')),
        );
      });
    });

    group('ResetPasswordSubmitted', () {
      test('supports value comparisons', () {
        expect(ResetPasswordSubmitted(), ResetPasswordSubmitted());
      });
    });
  });
}
