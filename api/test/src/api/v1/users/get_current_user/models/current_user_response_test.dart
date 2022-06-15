// ignore_for_file: prefer_const_constructors

import 'package:google_news_template_api/api.dart';
import 'package:test/test.dart';

void main() {
  group('CurrentUserResponse', () {
    test('can be (de)serialized', () {
      final response = CurrentUserResponse(
        user: User(id: 'id', subscription: SubscriptionPlan.basic),
      );

      expect(CurrentUserResponse.fromJson(response.toJson()), equals(response));
    });
  });
}
