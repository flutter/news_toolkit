import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';

void main() {
  group('SearchEvent', () {
    test('supports value comparisons', () {
      final event1 = LoadPopular();
      final event2 = LoadPopular();

      expect(event1, equals(event2));
    });
  });
}
