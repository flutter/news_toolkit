// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/search/search.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchEvent', () {
    group('SearchTermChanged', () {
      test('supports empty value comparisons', () {
        final event1 = SearchTermChanged();
        final event2 = SearchTermChanged();

        expect(event1, equals(event2));
      });
    });

    test('supports searchTerm value comparisons', () {
      final event1 = SearchTermChanged(searchTerm: 'keyword');
      final event2 = SearchTermChanged(searchTerm: 'keyword');

      expect(event1, equals(event2));
    });
  });
}
