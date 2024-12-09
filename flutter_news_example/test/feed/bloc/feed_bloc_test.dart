// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  initMockHydratedStorage();

  group('FeedBloc', () {
    late NewsRepository newsRepository;
    late FeedBloc feedBloc;

    final entertainmentCategory = Category(
      id: 'entertainment',
      name: 'Entertainment',
    );
    final healthCategory = Category(id: 'health', name: 'Health');

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
        entertainmentCategory.id: [
          SpacerBlock(spacing: Spacing.medium),
          DividerHorizontalBlock(),
        ],
        healthCategory.id: [
          DividerHorizontalBlock(),
        ],
      },
      hasMoreNews: {
        entertainmentCategory.id: true,
        healthCategory.id: false,
      },
    );

    setUp(() async {
      newsRepository = MockNewsRepository();
      feedBloc = FeedBloc(newsRepository: newsRepository);
    });

    test('can be (de)serialized', () {
      final serialized = feedBloc.toJson(feedStatePopulated);
      final deserialized = feedBloc.fromJson(serialized!);

      expect(deserialized, feedStatePopulated);
    });

    group('FeedRequested', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'when getFeed succeeds '
        'and there are more news to fetch',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => feedBloc,
        act: (bloc) => bloc.add(
          FeedRequested(category: entertainmentCategory),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(
            status: FeedStatus.populated,
            feed: {
              entertainmentCategory.id: feedResponse.feed,
            },
            hasMoreNews: {
              entertainmentCategory.id: true,
            },
          ),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'with appended feed for the given category '
        'when getFeed succeeds '
        'and there are no more news to fetch',
        seed: () => feedStatePopulated,
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => feedBloc,
        act: (bloc) => bloc.add(
          FeedRequested(category: entertainmentCategory),
        ),
        expect: () => <FeedState>[
          feedStatePopulated.copyWith(status: FeedStatus.loading),
          feedStatePopulated.copyWith(
            status: FeedStatus.populated,
            feed: feedStatePopulated.feed
              ..addAll({
                entertainmentCategory.id: [
                  ...feedStatePopulated.feed[entertainmentCategory.id]!,
                  ...feedResponse.feed,
                ],
              }),
            hasMoreNews: feedStatePopulated.hasMoreNews
              ..addAll({
                entertainmentCategory.id: false,
              }),
          ),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, error] '
        'when getFeed fails',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception()),
        build: () => feedBloc,
        act: (bloc) => bloc.add(
          FeedRequested(category: entertainmentCategory),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(status: FeedStatus.failure),
        ],
      );
    });

    group('FeedRefreshRequested', () {
      blocTest<FeedBloc, FeedState>(
        'emits [loading, populated] '
        'when getFeed succeeds '
        'and there is more news to fetch',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => feedBloc,
        act: (bloc) => bloc.add(
          FeedRefreshRequested(category: entertainmentCategory),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(
            status: FeedStatus.populated,
            feed: {
              entertainmentCategory.id: feedResponse.feed,
            },
            hasMoreNews: {
              entertainmentCategory.id: true,
            },
          ),
        ],
      );

      blocTest<FeedBloc, FeedState>(
        'emits [loading, error] '
        'when getFeed fails',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
          ),
        ).thenThrow(Exception()),
        build: () => feedBloc,
        act: (bloc) => bloc.add(
          FeedRefreshRequested(category: entertainmentCategory),
        ),
        expect: () => <FeedState>[
          FeedState(status: FeedStatus.loading),
          FeedState(status: FeedStatus.failure),
        ],
      );
    });

    group('FeedResumed', () {
      blocTest<FeedBloc, FeedState>(
        'emits [populated] '
        'when getFeed succeeds '
        'and there are more news to fetch for a single category',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => feedBloc,
        seed: () => FeedState(
          status: FeedStatus.populated,
          feed: {entertainmentCategory.id: []},
        ),
        act: (bloc) => bloc.add(FeedResumed()),
        expect: () => <FeedState>[
          FeedState(
            status: FeedStatus.populated,
            feed: {
              entertainmentCategory.id: feedResponse.feed,
            },
            hasMoreNews: {
              entertainmentCategory.id: true,
            },
          ),
        ],
        verify: (_) {
          verify(
            () => newsRepository.getFeed(
              categoryId: entertainmentCategory.id,
              offset: 0,
            ),
          ).called(1);
        },
      );

      blocTest<FeedBloc, FeedState>(
        'emits [populated] '
        'when getFeed succeeds '
        'and there are more news to fetch for multiple category',
        setUp: () => when(
          () => newsRepository.getFeed(
            categoryId: any(named: 'categoryId'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse),
        build: () => feedBloc,
        seed: () => FeedState(
          status: FeedStatus.populated,
          feed: {entertainmentCategory.id: [], healthCategory.id: []},
        ),
        act: (bloc) => bloc.add(FeedResumed()),
        expect: () => <FeedState>[
          FeedState(
            status: FeedStatus.populated,
            feed: {
              entertainmentCategory.id: feedResponse.feed,
              healthCategory.id: [],
            },
            hasMoreNews: {
              entertainmentCategory.id: true,
            },
          ),
          FeedState(
            status: FeedStatus.populated,
            feed: {
              entertainmentCategory.id: feedResponse.feed,
              healthCategory.id: feedResponse.feed,
            },
            hasMoreNews: {
              entertainmentCategory.id: true,
              healthCategory.id: true,
            },
          ),
        ],
        verify: (_) {
          verify(
            () => newsRepository.getFeed(
              categoryId: entertainmentCategory.id,
              offset: 0,
            ),
          ).called(1);
          verify(
            () => newsRepository.getFeed(
              categoryId: healthCategory.id,
              offset: 0,
            ),
          ).called(1);
        },
      );
    });
  });
}
