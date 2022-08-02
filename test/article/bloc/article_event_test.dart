// ignore_for_file: prefer_const_constructors

import 'package:analytics_repository/analytics_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';

void main() {
  group('ArticleEvent', () {
    group('ArticleRequested', () {
      test('supports value comparisons', () {
        final event1 = ArticleRequested();
        final event2 = ArticleRequested();

        expect(event1, equals(event2));
      });
    });

    group('ArticleContentSeen', () {
      test('supports value comparisons', () {
        final event1 = ArticleContentSeen(contentIndex: 10);
        final event2 = ArticleContentSeen(contentIndex: 10);

        expect(event1, equals(event2));
      });
    });

    group('ArticleRewardedAdWatched', () {
      test('supports value comparisons', () {
        final event1 = ArticleRewardedAdWatched();
        final event2 = ArticleRewardedAdWatched();

        expect(event1, equals(event2));
      });
    });

    group('ArticleCommented', () {
      test('supports value comparisons', () {
        final event1 = ArticleCommented(articleTitle: 'title');
        final event2 = ArticleCommented(articleTitle: 'title');

        expect(event1, equals(event2));
      });

      test('has ArticleCommentEvent', () {
        expect(
          ArticleCommented(articleTitle: 'title'),
          isA<AnalyticsEventMixin>().having(
            (event) => event.event,
            'event',
            equals(ArticleCommentEvent(articleTitle: 'title')),
          ),
        );
      });
    });

    group('ShareRequested', () {
      test('supports value comparisons', () {
        final event1 = ShareRequested(uri: Uri(path: 'text'));
        final event2 = ShareRequested(uri: Uri(path: 'text'));

        expect(event1, equals(event2));
      });

      test('has SocialShareEvent', () {
        expect(
          ShareRequested(uri: Uri(path: 'text')),
          isA<AnalyticsEventMixin>().having(
            (event) => event.event,
            'event',
            equals(SocialShareEvent()),
          ),
        );
      });
    });

    group('FacebookShareRequested', () {
      test('supports value comparisons', () {
        final event1 = FacebookShareRequested(uri: Uri(path: 'text'));
        final event2 = FacebookShareRequested(uri: Uri(path: 'text'));

        expect(event1, equals(event2));
      });

      test('has SocialShareEvent', () {
        expect(
          FacebookShareRequested(uri: Uri(path: 'text')),
          isA<AnalyticsEventMixin>().having(
            (event) => event.event,
            'event',
            equals(SocialShareEvent()),
          ),
        );
      });
    });
  });
}
