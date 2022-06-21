// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:share_launcher/share_launcher.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class MockShareLauncher extends Mock implements ShareLauncher {}

void main() {
  group('ArticleBloc', () {
    const articleId = 'articleId';
    final uri = Uri(path: 'text');

    late ArticleRepository articleRepository;
    late ShareLauncher shareLauncher;

    final articleResponse = ArticleResponse(
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
      content: [
        TextHeadlineBlock(text: 'text'),
        SpacerBlock(spacing: Spacing.large),
      ],
      hasMoreContent: true,
    );

    final relatedArticlesResponse = RelatedArticlesResponse(
      relatedArticles: articleResponse.content,
      totalCount: 2,
    );

    setUp(() {
      articleRepository = MockArticleRepository();

      when(
        () => articleRepository.getRelatedArticles(
          id: any(named: 'id'),
          offset: any(named: 'offset'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => relatedArticlesResponse);
      shareLauncher = MockShareLauncher();
    });

    test('can be instantiated', () {
      expect(
        ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
        isNotNull,
      );
    });

    group('ArticleRequested', () {
      setUp(() {
        when(articleRepository.incrementArticleViews).thenAnswer((_) async {});
        when(articleRepository.resetArticleViews).thenAnswer((_) async {});
        when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(3, DateTime(2022, 6, 7)));

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
            content: articleResponse.content,
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
        build: () => ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(status: ArticleStatus.loading),
          articleStatePopulated.copyWith(
            status: ArticleStatus.populated,
            content: [
              ...articleStatePopulated.content,
              ...articleResponse.content,
            ],
            relatedArticles: relatedArticlesResponse.relatedArticles,
            uri: articleResponse.url,
            hasMoreContent: false,
            isPreview: articleResponse.isPreview,
            isPremium: articleResponse.isPremium,
          )
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
        build: () => ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(status: ArticleStatus.failure),
        ],
        errors: () => [isA<Exception>()],
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
        build: () => ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          articleStatePopulated.copyWith(status: ArticleStatus.loading),
          articleStatePopulated.copyWith(status: ArticleStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );

      blocTest<ArticleBloc, ArticleState>(
        'calls ArticleRepository.resetArticleViews '
        'and ArticleRepository.incrementArticleViews '
        'and emits hasReachedArticleViewsLimit as false '
        'when the number of article views was never reset',
        setUp: () => when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(0, null)),
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
            content: articleResponse.content,
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
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
          shareLauncher: shareLauncher,
        ),
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
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
          shareLauncher: shareLauncher,
        ),
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
              shareLauncher: shareLauncher,
              articleRepository: articleRepository,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                content: articleResponse.content,
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
        final resetAt = DateTime(2022, 6, 7);
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
                content: articleResponse.content,
                uri: articleResponse.url,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: false,
                isPreview: articleResponse.isPreview,
                isPremium: articleResponse.isPremium,
              ),
            ],
            verify: (bloc) {
              verifyNever(articleRepository.resetArticleViews);
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
          'does not call ArticleRepository.incrementArticleViews '
          'and emits hasReachedArticleViewsLimit as true '
          'when the article views limit of 4 was reached '
          'and the the number of article views was last reset '
          'less than a day ago', () async {
        final resetAt = DateTime(2022, 6, 7);
        final now = DateTime(2022, 6, 7, 12, 0, 0);

        await withClock(Clock.fixed(now), () async {
          await testBloc<ArticleBloc, ArticleState>(
            setUp: () => when(articleRepository.fetchArticleViews)
                .thenAnswer((_) async => ArticleViews(4, resetAt)),
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
                content: articleResponse.content,
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
    });

    group('ArticleRewardedAdWatched', () {
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
        build: () => ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
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
        build: () => ArticleBloc(
          articleId: articleId,
          shareLauncher: shareLauncher,
          articleRepository: articleRepository,
        ),
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
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
          shareLauncher: shareLauncher,
        ),
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
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
          shareLauncher: shareLauncher,
        ),
        act: (bloc) => bloc.add(ArticleRewardedAdWatched()),
        expect: () => <ArticleState>[
          ArticleState.initial()
              .copyWith(status: ArticleStatus.rewardedAdWatchedFailure),
        ],
      );
    });
  });
}
