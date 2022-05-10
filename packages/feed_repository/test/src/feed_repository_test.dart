// ignore_for_file: prefer_const_constructors
import 'package:feed_repository/feed_repository.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class MockGoogleNewsTemplateApiClient extends Mock
    implements GoogleNewsTemplateApiClient {}

void main() {
  group('FeedRepository', () {
    late GoogleNewsTemplateApiClient apiClient;
    late FeedRepository feedRepository;

    setUp(() {
      apiClient = MockGoogleNewsTemplateApiClient();
      feedRepository = FeedRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(
        FeedRepository(apiClient: apiClient),
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
          feedRepository.getFeed(
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
          feedRepository.getFeed,
          throwsA(isA<GetFeedFailure>()),
        );
      });
    });

    group('FeedFailure', () {
      final error = Exception('errorMessage');
      const stackTrace = StackTrace.empty;

      group('GetFeedFailure', () {
        test('has correct props', () {
          expect(
            GetFeedFailure(error, stackTrace).props,
            [error, stackTrace],
          );
        });
      });
    });
  });
}
