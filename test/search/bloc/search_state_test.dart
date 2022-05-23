// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';
import 'package:google_news_template_api/client.dart';

void main() {
  group('SearchState', () {
    test('has correct initial status', () {
      expect(
        const SearchState.initial().status,
        equals(SearchStatus.initial),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          SearchState.initial().copyWith(),
          equals(SearchState.initial()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          SearchState.initial().copyWith(
            status: SearchStatus.loading,
          ),
          equals(
            SearchState(
              status: SearchStatus.loading,
              articles: const [],
              keyword: '',
              topics: const [],
            ),
          ),
        );
      });

      test(
          'returns object with updated articles '
          'when articles are passed', () {
        final articles = [DividerHorizontalBlock()];

        expect(
          SearchState.initial().copyWith(articles: articles),
          equals(
            SearchState(
              articles: articles,
              status: SearchStatus.initial,
              keyword: '',
              topics: const [],
            ),
          ),
        );
      });

      test(
          'returns object with updated keyword '
          'when keyword is passed', () {
        expect(
          SearchState.initial().copyWith(keyword: 'keyword'),
          equals(
            SearchState(
              articles: const [],
              status: SearchStatus.initial,
              keyword: 'keyword',
              topics: const [],
            ),
          ),
        );
      });
    });
  });
}
