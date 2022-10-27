// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';

void main() {
  group('LoginWithEmailLinkEvent', () {
    group('LoginWithEmailLinkSubmitted', () {
      test('supports value comparisons', () {
        final emailLink = Uri.https('example.com', '');
        expect(
          LoginWithEmailLinkSubmitted(emailLink),
          LoginWithEmailLinkSubmitted(emailLink),
        );
      });
    });
  });
}
