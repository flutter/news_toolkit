// ignore_for_file: prefer_const_constructors

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

    group('ArticleRewardedAdWatched', () {
      test('supports value comparisons', () {
        final event1 = ArticleRewardedAdWatched();
        final event2 = ArticleRewardedAdWatched();

        expect(event1, equals(event2));
      });
    });

    group('ShareRequested', () {
      test('supports value comparisons', () {
        final event1 = ShareRequested(uri: Uri(path: 'text'));
        final event2 = ShareRequested(uri: Uri(path: 'text'));

        expect(event1, equals(event2));
      });
    });
  });
}
