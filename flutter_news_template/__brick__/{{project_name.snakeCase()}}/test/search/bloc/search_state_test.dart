// ignore_for_file: prefer_const_constructors

import 'package:{{project_name.snakeCase()}}/search/search.dart';
import 'package:{{project_name.snakeCase()}}_api/client.dart';
import 'package:flutter_test/flutter_test.dart';

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
              topics: const [],
              searchType: SearchType.popular,
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
              topics: const [],
              searchType: SearchType.popular,
            ),
          ),
        );
      });

      test(
          'returns object with updated topics '
          'when topics are passed', () {
        final topics = ['Topic'];

        expect(
          SearchState.initial().copyWith(topics: topics),
          equals(
            SearchState(
              topics: topics,
              status: SearchStatus.initial,
              articles: const [],
              searchType: SearchType.popular,
            ),
          ),
        );
      });

      test(
          'returns object with updated searchType '
          'when searchType is passed', () {
        expect(
          SearchState.initial().copyWith(
            searchType: SearchType.relevant,
          ),
          equals(
            SearchState(
              topics: const [],
              status: SearchStatus.initial,
              articles: const [],
              searchType: SearchType.relevant,
            ),
          ),
        );
      });
    });
  });
}
