// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';

void main() {
  group('SearchEvent', () {
    group('LoadPopular', () {
      test('supports value comparisons', () {
        final event1 = LoadPopular();
        final event2 = LoadPopular();

        expect(event1, equals(event2));
      });
    });

    group('KeywordChanged', () {
      test('supports value comparisons', () {
        final event1 = KeywordChanged(keyword: 'keyword');
        final event2 = KeywordChanged(keyword: 'keyword');

        expect(event1, equals(event2));
      });
    });
  });
}
