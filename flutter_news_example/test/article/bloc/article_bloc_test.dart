// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:share_launcher/share_launcher.dart';

import '../../helpers/helpers.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class MockShareLauncher extends Mock implements ShareLauncher {}

void main() {
  initMockHydratedStorage();

  group('ArticleBloc', () {
    const articleId = 'articleId';
    final uri = Uri(path: 'text');

    late ArticleRepository articleRepository;
    late ShareLauncher shareLauncher;
    late ArticleBloc articleBloc;

    final articleResponse = ArticleResponse(
      title: 'title',
      content: [
        TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
        TextParagraphBlock(text: 'text'),
      ],
      totalCount: 4,
      url: Uri.parse('https://www.dglobe.com/'),
      isPreview: false,
      isPremium: true,
    );

    final articleStatePopulated = ArticleState(
      status: ArticleStatus.populated,
      title: articleResponse.title,
      content: [
        TextHeadlineBlock(text: 'text'),
        SpacerBlock(spacing: Spacing.large),
      ],
      uri: Uri.parse('https://www.dglobe.com/'),
      hasMoreContent: true,
      isPreview: false,
      isPremium: true,
    );

    final relatedArticlesResponse = RelatedArticlesResponse(
      relatedArticles: articleResponse.content,
      totalCount: 2,
    );

    setUp(() async {
      articleRepository = MockArticleRepository();
      shareLauncher = MockShareLauncher();

      articleBloc = ArticleBloc(
        articleId: articleId,
        shareLauncher: shareLauncher,
        articleRepository: articleRepository,
      );

      when(
        () => articleRepository.getRelatedArticles(
          id: any(named: 'id'),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => relatedArticlesResponse);
    });

    test('can be (de)serialized', () {
      final serialized = articleBloc.toJson(articleStatePopulated);
      final deserialized = articleBloc.fromJson(serialized!);

      expect(deserialized, articleStatePopulated);
    });

    group('on ArticleRequested', () {
      setUp(() {
        when(articleRepository.incrementArticleViews).thenAnswer((_) async {});
        when(articleRepository.resetArticleViews).thenAnswer((_) async {});
        when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(3, DateTime(2022, 6, 7)));
        when(() => articleRepository.incrementTotalArticleViews())
            .thenAnswer((_) async => {});
        when(() => articleRepository.fetchTotalArticleViews())
            .thenAnswer((_) async => 0);

        when(
          () => articleRepository.getArticle(
            id: articleId,
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => articleResponse);
      });

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] '
        'when getArticle succeeds '
        'and there is more content to fetch',
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(
            status: ArticleStatus.populated,
            title: articleResponse.title,
            content: articleResponse.content,
            contentTotalCount: articleResponse.totalCount,
            relatedArticles: [],
            uri: articleResponse.url,
            hasMoreContent: true,
            isPreview: articleResponse.isPreview,
            isPremium: articleResponse.isPremium,
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] '
        'with appended content and relatedArticles '
        'when getArticle succeeds '
        'and there is no more content to fetch',
        seed: () => articleStatePopulated,
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(status: ArticleStatus.loading),
          articleStatePopulated.copyWith(
            status: ArticleStatus.populated,
            content: [
              ...articleStatePopulated.content,
              ...articleResponse.content,
            ],
            contentTotalCount: articleResponse.totalCount,
            relatedArticles: relatedArticlesResponse.relatedArticles,
            hasMoreContent: false,
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, failure] '
        'when getArticle fails',
        setUp: () => when(
          () => articleRepository.getArticle(
            id: articleId,
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception()),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(status: ArticleStatus.failure),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, failure] '
        'when getRelatedArticles fails',
        seed: () => articleStatePopulated,
        setUp: () {
          when(
            () => articleRepository.getArticle(
              id: articleId,
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
            ),
          ).thenAnswer((_) async => articleResponse);
          when(
            () => articleRepository.getRelatedArticles(
              id: articleId,
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
            ),
          ).thenThrow(Exception());
        },
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(status: ArticleStatus.loading),
          articleStatePopulated.copyWith(status: ArticleStatus.failure),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'calls ArticleRepository.resetArticleViews '
        'and ArticleRepository.incrementArticleViews '
        'and emits hasReachedArticleViewsLimit as false '
        'when the number of article views was never reset',
        setUp: () => when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(0, null)),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(
            status: ArticleStatus.populated,
            title: articleResponse.title,
            content: articleResponse.content,
            contentTotalCount: articleResponse.totalCount,
            hasMoreContent: true,
            uri: articleResponse.url,
            hasReachedArticleViewsLimit: false,
            isPreview: articleResponse.isPreview,
            isPremium: articleResponse.isPremium,
          ),
        ],
        verify: (bloc) {
          verify(articleRepository.resetArticleViews).called(1);
          verify(articleRepository.incrementArticleViews).called(1);
          verify(
            () => articleRepository.getArticle(
              id: articleId,
              offset: any(named: 'offset'),
              limit: any(named: 'limit'),
              preview: false,
            ),
          ).called(1);
        },
      );

      blocTest<ArticleBloc, ArticleState>(
        'calls ShareLauncher.share '
        'and emits nothing '
        'when share succeeds',
        setUp: () => when(
          () => shareLauncher.share(text: any(named: 'text')),
        ).thenAnswer((_) async {}),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ShareRequested(uri: uri)),
        expect: () => <ArticleState>[],
        verify: (bloc) =>
            verify(() => shareLauncher.share(text: uri.toString())).called(1),
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [shareFailure] '
        'when share throws',
        setUp: () => when(
          () => shareLauncher.share(text: any(named: 'text')),
        ).thenThrow(Exception()),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ShareRequested(uri: uri)),
        expect: () => <ArticleState>[
          ArticleState.initial().copyWith(status: ArticleStatus.shareFailure),
        ],
      );

      test(
          'calls ArticleRepository.resetArticleViews '
          'and ArticleRepository.incrementArticleViews '
          'and emits hasReachedArticleViewsLimit as false '
          'when the number of article views was last reset '
          'more than a day ago', () async {
        final resetAt = DateTime(2022, 6, 7);
        final now = DateTime(2022, 6, 8, 0, 0, 1);
        await withClock(Clock.fixed(now), () async {
          await testBloc<ArticleBloc, ArticleState>(
            setUp: () => when(articleRepository.fetchArticleViews)
                .thenAnswer((_) async => ArticleViews(3, resetAt)),
            build: () => ArticleBloc(
              articleId: articleId,
              articleRepository: articleRepository,
              shareLauncher: shareLauncher,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                title: articleResponse.title,
                content: articleResponse.content,
                contentTotalCount: articleResponse.totalCount,
                uri: articleResponse.url,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: false,
                isPreview: articleResponse.isPreview,
                isPremium: articleResponse.isPremium,
              ),
            ],
            verify: (bloc) {
              verify(articleRepository.resetArticleViews).called(1);
              verify(articleRepository.incrementArticleViews).called(1);
              verify(
                () => articleRepository.getArticle(
                  id: articleId,
                  offset: any(named: 'offset'),
                  limit: any(named: 'limit'),
                  preview: false,
                ),
              ).called(1);
            },
          );
        });
      });

      test(
          'calls ArticleRepository.incrementArticleViews '
          'and emits hasReachedArticleViewsLimit as false '
          'when the article views limit of 4 was not reached '
          'and the the number of article views was last reset '
          'less than a day ago', () async {
        final resetAt = DateTime(2022, 6, 7, 1, 0, 0);
        final now = DateTime(2022, 6, 7, 12, 0, 0);
        await withClock(Clock.fixed(now), () async {
          await testBloc<ArticleBloc, ArticleState>(
            setUp: () => when(articleRepository.fetchArticleViews)
                .thenAnswer((_) async => ArticleViews(2, resetAt)),
            build: () => ArticleBloc(
              articleId: articleId,
              shareLauncher: shareLauncher,
              articleRepository: articleRepository,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                title: articleResponse.title,
                content: articleResponse.content,
                contentTotalCount: articleResponse.totalCount,
                uri: articleResponse.url,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: false,
                isPreview: articleResponse.isPreview,
                isPremium: articleResponse.isPremium,
              ),
            ],
            verify: (bloc) {
              verify(articleRepository.incrementArticleViews).called(1);
              verify(
                () => articleRepository.getArticle(
                  id: articleId,
                  offset: any(named: 'offset'),
                  limit: any(named: 'limit'),
                  preview: false,
                ),
              ).called(1);
              verifyNever(() => articleRepository.resetArticleViews());
            },
          );
        });
      });

      test(
          'does not call ArticleRepository.incrementArticleViews '
          'and emits hasReachedArticleViewsLimit as true '
          'when the article views limit of 4 was reached '
          'and the the number of article views was last reset '
          'less than a day ago', () async {
        final resetAt = DateTime(2022, 6, 7);
        final now = DateTime(2022, 6, 7, 12, 0, 0);

        withClock(Clock.fixed(now), () {
          testBloc<ArticleBloc, ArticleState>(
            seed: () => ArticleState(status: ArticleStatus.populated),
            setUp: () => when(articleRepository.fetchArticleViews)
                .thenAnswer((_) async => ArticleViews(4, resetAt)),
            build: () => ArticleBloc(
              articleId: articleId,
              articleRepository: articleRepository,
              shareLauncher: shareLauncher,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                title: articleResponse.title,
                content: articleResponse.content,
                contentTotalCount: articleResponse.totalCount,
                uri: articleResponse.url,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: true,
                isPreview: articleResponse.isPreview,
                isPremium: articleResponse.isPremium,
              ),
            ],
            verify: (bloc) {
              verifyNever(articleRepository.resetArticleViews);
              verifyNever(articleRepository.incrementArticleViews);
              verify(
                () => articleRepository.getArticle(
                  id: articleId,
                  offset: any(named: 'offset'),
                  limit: any(named: 'limit'),
                  preview: true,
                ),
              ).called(1);
            },
          );
        });
      });

      blocTest<ArticleBloc, ArticleState>(
        'emits showInterstitialAd true '
        'when fetchTotalArticleViews returns 4 ',
        setUp: () {
          when(() => articleRepository.fetchTotalArticleViews())
              .thenAnswer((_) async => 4);
        },
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(status: ArticleStatus.loading, showInterstitialAd: true),
          ArticleState(
            status: ArticleStatus.populated,
            title: articleResponse.title,
            content: articleResponse.content,
            contentTotalCount: articleResponse.totalCount,
            relatedArticles: [],
            uri: articleResponse.url,
            hasMoreContent: true,
            isPreview: articleResponse.isPreview,
            isPremium: articleResponse.isPremium,
            showInterstitialAd: true,
          ),
        ],
      );
    });

    group('on ArticleContentSeen', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits updated contentSeenCount '
        'when new count (contentIndex + 1) is higher than current',
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleContentSeen(contentIndex: 15)),
        seed: () => articleStatePopulated.copyWith(
          contentSeenCount: 10,
        ),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(
            contentSeenCount: 16,
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'does not emit updated contentSeenCount '
        'when new count (contentIndex + 1) is less than '
        'or equal to current',
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleContentSeen(contentIndex: 9)),
        seed: () => articleStatePopulated.copyWith(
          contentSeenCount: 10,
        ),
        expect: () => <ArticleState>[],
      );
    });

    group('on ArticleRewardedAdWatched', () {
      setUp(() {
        when(articleRepository.decrementArticleViews).thenAnswer((_) async {});
      });

      blocTest<ArticleBloc, ArticleState>(
        'calls ArticleRepository.decrementArticleViews '
        'and emits hasReachedArticleViewsLimit as false '
        'when the number of article views is less than '
        'the article views limit of 4',
        setUp: () => when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(3, null)),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRewardedAdWatched()),
        seed: () => articleStatePopulated.copyWith(
          hasReachedArticleViewsLimit: true,
        ),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(
            hasReachedArticleViewsLimit: false,
          ),
        ],
        verify: (bloc) =>
            verify(articleRepository.decrementArticleViews).called(1),
      );

      blocTest<ArticleBloc, ArticleState>(
        'calls ArticleRepository.decrementArticleViews '
        'and emits hasReachedArticleViewsLimit as true '
        'when the number of article views is equal to '
        'the article views limit of 4',
        setUp: () => when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(4, null)),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRewardedAdWatched()),
        seed: () => articleStatePopulated.copyWith(
          hasReachedArticleViewsLimit: false,
        ),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(
            hasReachedArticleViewsLimit: true,
          ),
        ],
        verify: (bloc) =>
            verify(articleRepository.decrementArticleViews).called(1),
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [rewardedAdWatchedFailure] '
        'when decrementArticleViews throws',
        setUp: () => when(articleRepository.decrementArticleViews)
            .thenThrow(Exception()),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRewardedAdWatched()),
        expect: () => <ArticleState>[
          ArticleState.initial()
              .copyWith(status: ArticleStatus.rewardedAdWatchedFailure),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [rewardedAdWatchedFailure] '
        'when fetchArticleViews throws',
        setUp: () =>
            when(articleRepository.fetchArticleViews).thenThrow(Exception()),
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleRewardedAdWatched()),
        expect: () => <ArticleState>[
          ArticleState.initial()
              .copyWith(status: ArticleStatus.rewardedAdWatchedFailure),
        ],
      );
    });

    group('on ArticleCommented', () {
      blocTest<ArticleBloc, ArticleState>(
        'does not emit a new state',
        build: () => articleBloc,
        act: (bloc) => bloc.add(ArticleCommented(articleTitle: 'title')),
        expect: () => <ArticleState>[],
      );
    });
  });
}
