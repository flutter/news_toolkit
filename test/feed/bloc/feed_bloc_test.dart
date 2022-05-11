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

    final feedResponse = FeedResponse(
      feed: [
        SectionHeaderBlock(title: 'title'),
        DividerHorizontalBlock(),
      ],
      totalCount: 4,
    );

    final feedStatePopulated = FeedState(
      status: FeedStatus.populated,
      feed: {
        Category.entertainment: [
          SpacerBlock(spacing: Spacing.medium),
          DividerHorizontalBlock(),
        ],
        Category.health: [
          DividerHorizontalBlock(),
        ],
      },
      hasMoreNews: {
        Category.entertainment: true,
        Category.health: false,
      },
    );

    setUp(() {
      newsRepository = MockNewsRepository();
    });

    test('can be instantiated', () {
      expect(
        FeedBloc(newsRepository: newsRepository),
        isNotNull,
      );
    });

    group('FeedRequested', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'when fetchFeed succeeds '
        'and there are more news to fetch',
        setUp: () => when(
          () => newsRepository.getFeed(
            category: any(named: 'category'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => FeedBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(
          FeedRequested(category: Category.entertainment),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(
            status: FeedStatus.populated,
            feed: {
              Category.entertainment: feedResponse.feed,
            },
            hasMoreNews: {
              Category.entertainment: true,
            },
          ),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'with appended feed for the given category '
        'when fetchFeed succeeds '
        'and there are no more news to fetch',
        seed: () => feedStatePopulated,
        setUp: () => when(
          () => newsRepository.getFeed(
            category: any(named: 'category'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => FeedBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(
          FeedRequested(category: Category.entertainment),
        ),
        expect: () => <FeedState>[
          feedStatePopulated.copyWith(status: FeedStatus.loading),
          feedStatePopulated.copyWith(
            status: FeedStatus.populated,
            feed: feedStatePopulated.feed
              ..addAll({
                Category.entertainment: [
                  ...feedStatePopulated.feed[Category.entertainment]!,
                  ...feedResponse.feed,
                ],
              }),
            hasMoreNews: feedStatePopulated.hasMoreNews
              ..addAll({
                Category.entertainment: false,
              }),
          )
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, error] '
        'when getFeed fails',
        setUp: () => when(
          () => newsRepository.getFeed(
            category: any(named: 'category'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception()),
        build: () => FeedBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(
          FeedRequested(category: Category.entertainment),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(status: FeedStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
