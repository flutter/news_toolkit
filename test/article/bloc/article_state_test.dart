// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:news_blocks/news_blocks.dart';

void main() {
  group('ArticleState', () {
    test('initial has correct status', () {
      expect(
        ArticleState.initial().status,
        equals(ArticleStatus.initial),
      );
    });

    test('supports value comparisons', () {
      expect(
        ArticleState.initial(),
        equals(ArticleState.initial()),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          ArticleState.initial().copyWith(),
          equals(ArticleState.initial()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          ArticleState.initial().copyWith(
            status: ArticleStatus.loading,
          ),
          equals(
            ArticleState(
              status: ArticleStatus.loading,
            ),
          ),
        );
      });

      test(
          'returns object with updated content '
          'when content is passed', () {
        final content = <NewsBlock>[
          TextCaptionBlock(text: 'text', color: TextCaptionColor.normal),
          TextParagraphBlock(text: 'text'),
        ];

        expect(
          ArticleState(status: ArticleStatus.populated).copyWith(
            content: content,
          ),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              content: content,
            ),
          ),
        );
      });

      test(
          'returns object with updated hasMoreContent '
          'when hasMoreContent is passed', () {
        const hasMoreContent = false;

        expect(
          ArticleState(
            status: ArticleStatus.populated,
            hasMoreContent: false,
          ).copyWith(hasMoreContent: hasMoreContent),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              hasMoreContent: hasMoreContent,
            ),
          ),
        );
      });
    });
  });
}
