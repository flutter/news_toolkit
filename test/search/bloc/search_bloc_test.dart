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

    blocTest<SearchBloc, SearchState>(
      'emits [loading, populated] '
      'with articles and topics '
      'when popularSearch succeeds.',
      setUp: () => when(() => newsRepository.popularSearch()).thenAnswer(
        (invocation) => Future.value(popularResponseSuccess),
      ),
      build: () => SearchBloc(newsRepository: newsRepository),
      act: (bloc) => bloc.add(LoadPopular()),
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
      act: (bloc) => bloc.add(LoadPopular()),
      expect: () => <SearchState>[
        const SearchState.initial().copyWith(status: SearchStatus.loading),
        const SearchState.initial().copyWith(
          status: SearchStatus.failure,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, populated] '
      'with articles and topics '
      'when relevantSearch succeeds.',
      setUp: () => when(
        () => newsRepository.relevantSearch(
          term: any(named: 'term'),
        ),
      ).thenAnswer(
        (invocation) => Future.value(relevantResponseSuccess),
      ),
      build: () => SearchBloc(newsRepository: newsRepository),
      act: (bloc) => bloc.add(KeywordChanged(keyword: 'term')),
      expect: () => <SearchState>[
        SearchState(
          keyword: 'term',
          status: SearchStatus.loading,
          articles: const [],
          topics: const [],
        ),
        SearchState(
          keyword: 'term',
          status: SearchStatus.populated,
          articles: popularResponseSuccess.articles,
          topics: popularResponseSuccess.topics,
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [loading, failure] '
      'when relevantSearch throws.',
      setUp: () => when(() => newsRepository.relevantSearch(term: 'term'))
          .thenThrow(RelevantSearchFailure),
      build: () => SearchBloc(newsRepository: newsRepository),
      act: (bloc) => bloc.add(KeywordChanged(keyword: 'term')),
      expect: () => <SearchState>[
        SearchState(
          keyword: 'term',
          status: SearchStatus.loading,
          articles: const [],
          topics: const [],
        ),
        SearchState(
          keyword: 'term',
          status: SearchStatus.failure,
          articles: const [],
          topics: const [],
        ),
      ],
    );
  });
}
