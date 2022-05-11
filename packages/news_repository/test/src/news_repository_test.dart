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

    group('FeedFailure', () {
      final error = Exception('errorMessage');

      group('GetFeedFailure', () {
        test('has correct props', () {
          expect(
            GetFeedFailure(error).props,
            [error],
          );
        });
      });

      group('GetCategoriesFailure', () {
        test('has correct props', () {
          expect(
            GetCategoriesFailure(error, stackTrace).props,
            [error, stackTrace],
          );
        });
      });
    });
  });
}
