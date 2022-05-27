// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('ArticleBloc', () {
    const articleId = 'articleId';

    late NewsRepository newsRepository;

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
      newsRepository = MockNewsRepository();
    });

    test('can be instantiated', () {
      expect(
        ArticleBloc(
          articleId: articleId,
          newsRepository: newsRepository,
        ),
        isNotNull,
      );
    });

    group('ArticleRequested', () {
      blocTest<ArticleBloc, ArticleState>(
        'emits [loading, populated] '
        'when getArticle succeeds '
        'and there is more content to fetch',
        setUp: () => when(
          () => newsRepository.getArticle(
            id: articleId,
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => articleResponse),
        build: () => ArticleBloc(
          articleId: articleId,
          newsRepository: newsRepository,
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
        setUp: () => when(
          () => newsRepository.getArticle(
            id: articleId,
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => articleResponse),
        build: () => ArticleBloc(
          articleId: articleId,
          newsRepository: newsRepository,
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
          () => newsRepository.getArticle(
            id: articleId,
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception()),
        build: () => ArticleBloc(
          articleId: articleId,
          newsRepository: newsRepository,
        ),
        act: (bloc) => bloc.add(ArticleRequested()),
        expect: () => <ArticleState>[
          ArticleState(status: ArticleStatus.loading),
          ArticleState(status: ArticleStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
