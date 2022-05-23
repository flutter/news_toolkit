// ignore_for_file: prefer_const_constructors
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

void main() {
  group('NewsRepository', () {
    late GoogleNewsTemplateApiClient apiClient;
    late NewsRepository newsRepository;

    setUp(() {
      apiClient = MockGoogleNewsTemplateApiClient();
      newsRepository = NewsRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(
        NewsRepository(apiClient: apiClient),
        isNotNull,
      );
    });

    group('getArticle', () {
      test(
          'returns ArticleResponse '
          'from ApiClient.getArticle', () {
        final content = <NewsBlock>[
          TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
          TextParagraphBlock(text: 'text'),
        ];

        final articleResponse = ArticleResponse(
          content: content,
          totalCount: content.length,
        );

        when(
          () => apiClient.getArticle(
            id: any(named: 'id'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => articleResponse);

        expect(
          newsRepository.getArticle(
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
          () => newsRepository.getArticle(id: 'id'),
          throwsA(isA<GetArticleFailure>()),
        );
      });
    });

    group('getFeed', () {
      test(
          'returns FeedResponse '
          'from ApiClient.getFeed', () {
        final feed = <NewsBlock>[
          SpacerBlock(spacing: Spacing.extraLarge),
          DividerHorizontalBlock(),
        ];

        final feedResponse = FeedResponse(
          feed: feed,
          totalCount: feed.length,
        );

        when(
          () => apiClient.getFeed(
            category: any(named: 'category'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenAnswer((_) async => feedResponse);

        expect(
          newsRepository.getFeed(
            category: Category.entertainment,
            offset: 10,
            limit: 20,
          ),
          completion(equals(feedResponse)),
        );

        verify(
          () => apiClient.getFeed(
            category: Category.entertainment,
            offset: 10,
            limit: 20,
          ),
        ).called(1);
      });

      test(
          'throws GetFeedFailure '
          'if ApiClient.getFeed fails', () async {
        when(
          () => apiClient.getFeed(
            category: any(named: 'category'),
            offset: any(named: 'offset'),
            limit: any(named: 'limit'),
          ),
        ).thenThrow(Exception);

        expect(
          newsRepository.getFeed,
          throwsA(isA<GetFeedFailure>()),
        );
      });
    });

    group('getCategories', () {
      test(
          'returns CategoriesResponse '
          'from ApiClient.getCategories', () {
        const categoriesResponse = CategoriesResponse(
          categories: [
            Category.top,
            Category.health,
          ],
        );

        when(apiClient.getCategories)
            .thenAnswer((_) async => categoriesResponse);

        expect(
          newsRepository.getCategories(),
          completion(equals(categoriesResponse)),
        );

        verify(apiClient.getCategories).called(1);
      });

      test(
          'throws GetCategoriesFailure '
          'if ApiClient.getCategories fails', () async {
        when(apiClient.getCategories).thenThrow(Exception);

        expect(
          newsRepository.getCategories,
          throwsA(isA<GetCategoriesFailure>()),
        );
      });
    });

    group('subscribeToNewsletter', () {
      test('completes from ApiClient.subscribeToNewsletter', () {
        when(
          () => apiClient.subscribeToNewsletter(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async {});

        final response = newsRepository.subscribeToNewsletter(email: 'email');

        expect(response, completes);

        verify(
          () => apiClient.subscribeToNewsletter(
            email: 'email',
          ),
        ).called(1);
      });

      test('throws GetFeedFailure if ApiClient.subscribeToNewsletter', () {
        when(
          () => apiClient.subscribeToNewsletter(
            email: any(named: 'email'),
          ),
        ).thenThrow(Exception);

        final response = newsRepository.subscribeToNewsletter(email: 'email');

        expect(response, throwsA(isA<GetFeedFailure>()));
      });
    });

    group('popularSearch', () {
      test(
          'returns PopularSearchResponse '
          'from ApiClient.popularSearch', () {
        const popularResponse = PopularSearchResponse(
          articles: [
            SpacerBlock(spacing: Spacing.extraLarge),
            DividerHorizontalBlock(),
          ],
          topics: ['Topic'],
        );

        when(apiClient.popularSearch).thenAnswer((_) async => popularResponse);

        expect(
          newsRepository.popularSearch(),
          completion(equals(popularResponse)),
        );

        verify(apiClient.popularSearch).called(1);
      });

      test(
          'throws PopularSearchFailure '
          'if ApiClient.popularSearch fails', () async {
        when(apiClient.popularSearch).thenThrow(Exception);

        expect(
          newsRepository.popularSearch,
          throwsA(isA<PopularSearchFailure>()),
        );
      });
    });

    group('relevantSearch', () {
      test(
          'returns RelevantSearchResponse '
          'from ApiClient.relevantSearch', () {
        const relevantResponse = RelevantSearchResponse(
          articles: [
            SpacerBlock(spacing: Spacing.extraLarge),
            DividerHorizontalBlock(),
          ],
          topics: ['Topic'],
        );

        when(() => apiClient.relevantSearch(term: ''))
            .thenAnswer((_) async => relevantResponse);

        expect(
          newsRepository.relevantSearch(term: ''),
          completion(equals(relevantResponse)),
        );

        verify(() => apiClient.relevantSearch(term: any(named: 'term')))
            .called(1);
      });

      test(
          'throws RelevantSearchFailure '
          'if ApiClient.relevantSearch fails', () async {
        when(() => apiClient.relevantSearch(term: any(named: 'term')))
            .thenThrow(Exception);

        expect(
          newsRepository.relevantSearch(term: 'term'),
          throwsA(isA<RelevantSearchFailure>()),
        );
      });
    });

    group('NewsFailure', () {
      final error = Exception('errorMessage');

      group('GetArticleFailure', () {
        test('has correct props', () {
          expect(GetArticleFailure(error).props, [error]);
        });
      });

      group('GetFeedFailure', () {
        test('has correct props', () {
          expect(GetFeedFailure(error).props, [error]);
        });
      });

      group('GetCategoriesFailure', () {
        test('has correct props', () {
          expect(GetCategoriesFailure(error).props, [error]);
        });
      });
    });
  });
}
