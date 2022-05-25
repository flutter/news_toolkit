// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('SearchBloc', () {
    late NewsRepository newsRepository;

    const popularResponseSuccess = PopularSearchResponse(
      articles: [DividerHorizontalBlock()],
      topics: ['test'],
    );

    const relevantResponseSuccess = RelevantSearchResponse(
      articles: [DividerHorizontalBlock()],
      topics: ['test'],
    );

    setUpAll(() {
      newsRepository = MockNewsRepository();
    });

    group('on PopularSearchRequested', () {
      blocTest<SearchBloc, SearchState>(
        'emits [loading, populated] '
        'with articles and topics '
        'when popularSearch succeeds.',
        setUp: () => when(() => newsRepository.popularSearch()).thenAnswer(
          (_) async => popularResponseSuccess,
        ),
        build: () => SearchBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(PopularSearchRequested()),
        expect: () => <SearchState>[
          const SearchState.initial().copyWith(status: SearchStatus.loading),
          const SearchState.initial().copyWith(
            status: SearchStatus.populated,
            articles: popularResponseSuccess.articles,
            topics: popularResponseSuccess.topics,
          ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, failure] '
        'when popularSearch throws.',
        setUp: () => when(() => newsRepository.popularSearch())
            .thenThrow(PopularSearchFailure),
        build: () => SearchBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(PopularSearchRequested()),
        expect: () => <SearchState>[
          const SearchState.initial().copyWith(
            status: SearchStatus.loading,
            searchType: SearchType.popular,
          ),
          const SearchState.initial().copyWith(
            status: SearchStatus.failure,
            searchType: SearchType.popular,
          ),
        ],
      );
    });

    group('on SearchTermChanged', () {
      blocTest<SearchBloc, SearchState>(
        'emits [loading, populated] '
        'with articles and topics '
        'and awaited debounce time '
        'when relevantSearch succeeds',
        setUp: () => when(
          () => newsRepository.relevantSearch(
            term: any(named: 'term'),
          ),
        ).thenAnswer(
          (_) async => relevantResponseSuccess,
        ),
        build: () => SearchBloc(newsRepository: newsRepository),
        act: (bloc) {
          bloc.add(SearchTermChanged(searchTerm: 'term'));
        },
        wait: const Duration(milliseconds: 300),
        expect: () => <SearchState>[
          SearchState(
            status: SearchStatus.loading,
            articles: const [],
            topics: const [],
            searchType: SearchType.relevant,
          ),
          SearchState(
            status: SearchStatus.populated,
            articles: popularResponseSuccess.articles,
            topics: popularResponseSuccess.topics,
            searchType: SearchType.relevant,
          ),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [loading, failure] '
        'when relevantSearch throws.',
        setUp: () => when(
          () => newsRepository.relevantSearch(
            term: any(named: 'term'),
          ),
        ).thenThrow(RelevantSearchFailure),
        build: () => SearchBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(SearchTermChanged(searchTerm: 'term')),
        wait: const Duration(milliseconds: 300),
        expect: () => <SearchState>[
          SearchState(
            status: SearchStatus.loading,
            articles: const [],
            topics: const [],
            searchType: SearchType.relevant,
          ),
          SearchState(
            status: SearchStatus.failure,
            articles: const [],
            topics: const [],
            searchType: SearchType.relevant,
          ),
        ],
      );
    });
  });
}
