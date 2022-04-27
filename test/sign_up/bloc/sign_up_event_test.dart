// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/sign_up/sign_up.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpEmailChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpEmailChanged('test@gmail.com'),
          SignUpEmailChanged('test@gmail.com'),
        );
        expect(
          SignUpEmailChanged(''),
          isNot(SignUpEmailChanged('test@gmail.com')),
        );
      });
    });

    group('SignUpSubmitted', () {
      test('supports value comparisons', () {
        expect(SignUpSubmitted(), SignUpSubmitted());
      });
    });
  });
}
