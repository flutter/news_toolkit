// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginWithEmailLinkState', () {
    test('supports value comparisons', () {
      expect(LoginWithEmailLinkState(), LoginWithEmailLinkState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginWithEmailLinkState().copyWith(), LoginWithEmailLinkState());
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginWithEmailLinkState()
            .copyWith(status: LoginWithEmailLinkStatus.success),
        LoginWithEmailLinkState(
          status: LoginWithEmailLinkStatus.success,
        ),
      );
    });
  });
}
