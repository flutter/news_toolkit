// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticationUser', () {
    test('supports value equality', () {
      final userA = AuthenticationUser(id: 'A');
      final secondUserA = AuthenticationUser(id: 'A');
      final userB = AuthenticationUser(id: 'B');

      expect(userA, equals(secondUserA));
      expect(userA, isNot(equals(userB)));
    });

    test('isAnonymous returns true for anonymous user', () {
      expect(AuthenticationUser.anonymous.isAnonymous, isTrue);
    });
  });
}
