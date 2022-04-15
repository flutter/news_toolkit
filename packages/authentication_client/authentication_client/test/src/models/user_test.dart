// ignore_for_file: prefer_const_constructors

import 'package:authentication_client/authentication_client.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    test('supports value equality', () {
      final userA = User(id: 'A');
      final secondUserA = User(id: 'A');
      final userB = User(id: 'B');

      expect(userA, equals(secondUserA));
      expect(userA, isNot(equals(userB)));
    });
  });
}
