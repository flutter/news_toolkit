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
          'returns object with updated title '
          'when title is passed', () {
        expect(
          ArticleState(
            status: ArticleStatus.populated,
          ).copyWith(title: 'title'),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              title: 'title',
            ),
          ),
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

      test(
          'returns object with updated relatedArticles '
          'when relatedArticles is passed', () {
        const relatedArticles = <NewsBlock>[DividerHorizontalBlock()];

        expect(
          ArticleState(
            status: ArticleStatus.populated,
          ).copyWith(relatedArticles: relatedArticles),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              relatedArticles: relatedArticles,
            ),
          ),
        );
      });

      test(
          'returns object with updated hasReachedArticleViewsLimit '
          'when hasReachedArticleViewsLimit is passed', () {
        const hasReachedArticleViewsLimit = true;

        expect(
          ArticleState(
            status: ArticleStatus.populated,
          ).copyWith(hasReachedArticleViewsLimit: hasReachedArticleViewsLimit),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              hasReachedArticleViewsLimit: hasReachedArticleViewsLimit,
            ),
          ),
        );
      });

      test(
          'returns object with updated isPreview '
          'when isPreview is passed', () {
        const isPreview = true;

        expect(
          ArticleState(
            status: ArticleStatus.populated,
          ).copyWith(isPreview: isPreview),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              isPreview: isPreview,
            ),
          ),
        );
      });

      test(
          'returns object with updated isPremium '
          'when isPremium is passed', () {
        const isPremium = true;

        expect(
          ArticleState(
            status: ArticleStatus.populated,
          ).copyWith(isPremium: isPremium),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              isPremium: isPremium,
            ),
          ),
        );
      });
    });
  });
}
