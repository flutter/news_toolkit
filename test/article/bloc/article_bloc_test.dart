// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  group('ArticleBloc', () {
    const articleId = 'articleId';

    late ArticleRepository articleRepository;

    final articleResponse = ArticleResponse(
      content: [
        TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
        TextParagraphBlock(text: 'text'),
      ],
      totalCount: 4,
      url: Uri.parse('https://www.dglobe.com/'),
    );

    final articleStatePopulated = ArticleState(
      status: ArticleStatus.populated,
      content: [
        TextHeadlineBlock(text: 'text'),
        SpacerBlock(spacing: Spacing.large),
      ],
      hasMoreContent: true,
    );

    setUp(() {
      articleRepository = MockArticleRepository();
    });

    test('can be instantiated', () {
      expect(
        ArticleBloc(
          articleId: articleId,
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
          ),
        ).thenAnswer((_) async => articleResponse);
      });

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] '
        'when getArticle succeeds '
        'and there is more content to fetch',
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(
            status: ArticleStatus.populated,
            content: articleResponse.content,
            hasMoreContent: true,
          ),
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] '
        'with appended content '
        'when getArticle succeeds '
        'and there is no more content to fetch',
        seed: () => articleStatePopulated,
        build: () => ArticleBloc(
          articleId: articleId,
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
            hasMoreContent: false,
          )
        ],
      );

      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, error] '
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
        'calls ArticleRepository.resetArticleViews and '
        'ArticleRepository.incrementArticleViews '
        'and emits hasReachedArticleViewsLimit as false '
        'when the number of article views was never reset',
        setUp: () => when(articleRepository.fetchArticleViews)
            .thenAnswer((_) async => ArticleViews(0, null)),
        build: () => ArticleBloc(
          articleId: articleId,
          articleRepository: articleRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(
            status: ArticleStatus.populated,
            content: articleResponse.content,
            hasMoreContent: true,
            hasReachedArticleViewsLimit: false,
          ),
        ],
        verify: (bloc) {
          verify(articleRepository.resetArticleViews).called(1);
          verify(articleRepository.incrementArticleViews).called(1);
        },
      );

      test(
          'calls ArticleRepository.resetArticleViews and '
          'ArticleRepository.incrementArticleViews '
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
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                content: articleResponse.content,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: false,
              ),
            ],
            verify: (bloc) {
              verify(articleRepository.resetArticleViews).called(1);
              verify(articleRepository.incrementArticleViews).called(1);
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
              articleRepository: articleRepository,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                content: articleResponse.content,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: false,
              ),
            ],
            verify: (bloc) {
              verifyNever(articleRepository.resetArticleViews);
              verify(articleRepository.incrementArticleViews).called(1);
            },
          );
        });
      });

      test(
          'calls ArticleRepository.incrementArticleViews '
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
              articleRepository: articleRepository,
            ),
            act: (bloc) => bloc.add(ArticleRequested()),
            expect: () => <ArticleState>[
              ArticleState(status: ArticleStatus.loading),
              ArticleState(
                status: ArticleStatus.populated,
                content: articleResponse.content,
                hasMoreContent: true,
                hasReachedArticleViewsLimit: true,
              ),
            ],
            verify: (bloc) {
              verifyNever(articleRepository.resetArticleViews);
              verify(articleRepository.incrementArticleViews).called(1);
            },
          );
        });
      });
    });
  });
}
