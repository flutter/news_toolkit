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
  });
}
