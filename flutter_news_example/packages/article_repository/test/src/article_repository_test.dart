import 'package:article_repository/article_repository.dart';
import 'package:clock/clock.dart';
import 'package:flutter_news_example_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockFlutterNewsExampleApiClient extends Mock
    implements FlutterNewsExampleApiClient {}

class MockArticleStorage extends Mock implements ArticleStorage {}

void main() {
  group('ArticleRepository', () {
    late FlutterNewsExampleApiClient apiClient;
    late ArticleStorage storage;
    late ArticleRepository articleRepository;

    setUp(() {
      apiClient = MockFlutterNewsExampleApiClient();
      storage = MockArticleStorage();
      when(() => storage.setArticleViews(any())).thenAnswer((_) async {});
      when(() => storage.setArticleViewsResetDate(any()))
          .thenAnswer((_) async {});

      articleRepository =
          ArticleRepository(apiClient: apiClient, storage: storage);
    });

    test('can be instantiated', () {
      expect(
        ArticleRepository(apiClient: apiClient, storage: storage),
        isNotNull,
      );
    });

    group('getArticle', () {
      test(
          'returns ArticleResponse '
          'from ApiClient.getArticle', () {
        const content = <NewsBlock>[
          TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
          TextParagraphBlock(text: 'text'),
        ];

        final articleResponse = ArticleResponse(
          title: 'title',
          content: content,
          totalCount: content.length,
          url: Uri.parse('https://www.dglobe.com/'),
          isPremium: false,
          isPreview: false,
        );

        when(
          () => apiClient.getArticle(
            id: any(named: 'id'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
            preview: any(named: 'preview'),
          ),
        ).thenAnswer((_) async => articleResponse);

        expect(
          articleRepository.getArticle(
            id: 'id',
            offset: 10,
            limit: 20,
          ),
          completion(equals(articleResponse)),
        );

        verify(
          () => apiClient.getArticle(
            id: 'id',
            offset: 10,
            limit: 20,
          ),
        ).called(1);
      });

      test(
          'throws GetArticleFailure '
          'if ApiClient.getArticle fails', () async {
        when(
          () => apiClient.getArticle(
            id: any(named: 'id'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception);

        expect(
          () => articleRepository.getArticle(id: 'id'),
          throwsA(isA<GetArticleFailure>()),
        );
      });
    });

    group('getRelatedArticles', () {
      test(
          'returns RelatedArticlesResponse '
          'from ApiClient.getRelatedArticles', () async {
        const relatedArticlesResponse = RelatedArticlesResponse(
          relatedArticles: [
            SpacerBlock(spacing: Spacing.extraLarge),
            DividerHorizontalBlock(),
          ],
          totalCount: 2,
        );

        when(
          () => apiClient.getRelatedArticles(
            id: any(named: 'id'),
          ),
        ).thenAnswer((_) async => relatedArticlesResponse);

        final response = await articleRepository.getRelatedArticles(id: 'id');

        expect(response, equals(relatedArticlesResponse));
      });

      test(
          'throws GetRelatedArticlesFailure '
          'if ApiClient.getRelatedArticles fails', () async {
        when(
          () => apiClient.getRelatedArticles(
            id: any(named: 'id'),
          ),
        ).thenThrow(Exception());

        expect(
          articleRepository.getRelatedArticles(id: 'id'),
          throwsA(isA<GetRelatedArticlesFailure>()),
        );
      });
    });

    group('incrementArticleViews', () {
      test(
          'calls ArticleStorage.setArticleViews '
          'with current article views increased by 1', () async {
        const currentArticleViews = 3;
        when(storage.fetchArticleViews)
            .thenAnswer((_) async => currentArticleViews);

        await articleRepository.incrementArticleViews();

        verify(storage.fetchArticleViews).called(1);
        verify(() => storage.setArticleViews(currentArticleViews + 1))
            .called(1);
      });

      test(
          'throws an IncrementArticleViewsFailure '
          'when incrementing article views fails', () async {
        when(() => storage.setArticleViews(any())).thenThrow(Exception());

        expect(
          () => articleRepository.incrementArticleViews(),
          throwsA(isA<IncrementArticleViewsFailure>()),
        );
      });
    });

    group('decrementArticleViews', () {
      test(
          'calls ArticleStorage.setArticleViews '
          'with current article views decreased by 1', () async {
        const currentArticleViews = 3;
        when(storage.fetchArticleViews)
            .thenAnswer((_) async => currentArticleViews);

        await articleRepository.decrementArticleViews();

        verify(storage.fetchArticleViews).called(1);
        verify(() => storage.setArticleViews(currentArticleViews - 1))
            .called(1);
      });

      test(
          'throws a DecrementArticleViewsFailure '
          'when decrementing article views fails', () async {
        when(() => storage.setArticleViews(any())).thenThrow(Exception());

        expect(
          () => articleRepository.decrementArticleViews(),
          throwsA(isA<DecrementArticleViewsFailure>()),
        );
      });
    });

    group('resetArticleViews', () {
      test(
          'calls ArticleStorage.setArticleViews '
          'with 0 article views', () async {
        await articleRepository.resetArticleViews();
        verify(() => storage.setArticleViews(0)).called(1);
      });

      test(
          'calls ArticleStorage.setArticleViewsResetDate '
          'with current date', () async {
        final now = DateTime(2022, 6, 7);
        await withClock(Clock.fixed(now), () async {
          await articleRepository.resetArticleViews();
          verify(() => storage.setArticleViewsResetDate(now)).called(1);
        });
      });

      test(
          'throws a ResetArticleViewsFailure '
          'when resetting article views fails', () async {
        when(() => storage.setArticleViews(any())).thenThrow(Exception());

        expect(
          () => articleRepository.resetArticleViews(),
          throwsA(isA<ResetArticleViewsFailure>()),
        );
      });
    });

    group('fetchArticleViews', () {
      test(
          'returns the number of article views '
          'from ArticleStorage.fetchArticleViews', () async {
        const currentArticleViews = 3;
        when(storage.fetchArticleViews)
            .thenAnswer((_) async => currentArticleViews);
        when(storage.fetchArticleViewsResetDate).thenAnswer((_) async => null);
        final result = await articleRepository.fetchArticleViews();
        expect(result.views, equals(currentArticleViews));
      });

      test(
          'returns the reset date of the number of article views '
          'from ArticleStorage.fetchArticleViewsResetDate', () async {
        final resetDate = DateTime(2022, 6, 7);
        when(storage.fetchArticleViews).thenAnswer((_) async => 0);
        when(storage.fetchArticleViewsResetDate)
            .thenAnswer((_) async => resetDate);
        final result = await articleRepository.fetchArticleViews();
        expect(result.resetAt, equals(resetDate));
      });

      test(
          'throws a FetchArticleViewsFailure '
          'when fetching article views fails', () async {
        when(storage.fetchArticleViews).thenThrow(Exception());

        expect(
          () => articleRepository.fetchArticleViews(),
          throwsA(isA<FetchArticleViewsFailure>()),
        );
      });
    });

    group('ArticleFailure', () {
      final error = Exception('errorMessage');

      group('GetArticleFailure', () {
        test('has correct props', () {
          expect(GetArticleFailure(error).props, [error]);
        });
      });

      group('GetRelatedArticlesFailure', () {
        test('has correct props', () {
          expect(GetRelatedArticlesFailure(error).props, [error]);
        });
      });

      group('IncrementArticleViewsFailure', () {
        test('has correct props', () {
          expect(IncrementArticleViewsFailure(error).props, [error]);
        });
      });

      group('DecrementArticleViewsFailure', () {
        test('has correct props', () {
          expect(DecrementArticleViewsFailure(error).props, [error]);
        });
      });

      group('ResetArticleViewsFailure', () {
        test('has correct props', () {
          expect(ResetArticleViewsFailure(error).props, [error]);
        });
      });

      group('FetchArticleViewsFailure', () {
        test('has correct props', () {
          expect(FetchArticleViewsFailure(error).props, [error]);
        });
      });
    });
  });
}
