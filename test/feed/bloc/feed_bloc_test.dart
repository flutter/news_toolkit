// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('FeedBloc', () {
    late NewsRepository newsRepository;

    final feedResponse = FeedResponse(feed: [], totalCount: 0);

    setUp(() {
      newsRepository = MockNewsRepository();
    });

    test('can be instantiated', () {
      expect(
        FeedBloc(newsRepository: newsRepository),
        isNotNull,
      );
    });

    group('FetchFeed', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'when fetchFeed succeeds',
        setUp: () =>
            when(newsRepository.getFeed).thenAnswer((_) async => feedResponse),
        build: () => FeedBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(FetchFeed()),
        expect: () => <FeedState>[
          const FeedLoading(),
          FeedPopulated(feedResponse),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, error] '
        'when fetchFeed fails',
        setUp: () => when(newsRepository.getFeed).thenThrow(Exception()),
        build: () => FeedBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(FetchFeed()),
        expect: () => <FeedState>[
          const FeedLoading(),
          const FeedError(),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
