// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
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

    group('contentMilestone', () {
      test(
          'returns 0 '
          'when contentTotalCount is null', () {
        expect(
          ArticleState.initial().copyWith(contentSeenCount: 5).contentMilestone,
          isZero,
        );
      });

      test(
          'returns 0 '
          'when isPreview is true', () {
        expect(
          ArticleState.initial()
              .copyWith(contentSeenCount: 5, isPreview: true)
              .contentMilestone,
          isZero,
        );
      });

      test(
          'returns 0 '
          'when user has seen less than 25% of content', () {
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 0,
                contentTotalCount: 100,
              )
              .contentMilestone,
          isZero,
        );
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 24,
                contentTotalCount: 100,
              )
              .contentMilestone,
          isZero,
        );
      });

      test(
          'returns 25 '
          'when user has seen at least 25% of content '
          'and less than 50%', () {
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 25,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(25),
        );
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 49,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(25),
        );
      });

      test(
          'returns 50 '
          'when user has seen at least 50% of content '
          'and less than 75%', () {
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 50,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(50),
        );
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 74,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(50),
        );
      });

      test(
          'returns 75 '
          'when user has seen at least 75% of content '
          'and less than 100%', () {
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 75,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(75),
        );
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 99,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(75),
        );
      });

      test(
          'returns 100 '
          'when user has seen 100% of content', () {
        expect(
          ArticleState.initial()
              .copyWith(
                contentSeenCount: 100,
                contentTotalCount: 100,
              )
              .contentMilestone,
          equals(100),
        );
      });
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
          'returns object with updated contentTotalCount '
          'when contentTotalCount is passed', () {
        const contentTotalCount = 10;
        expect(
          ArticleState(status: ArticleStatus.populated).copyWith(
            contentTotalCount: contentTotalCount,
          ),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              contentTotalCount: contentTotalCount,
            ),
          ),
        );
      });

      test(
          'returns object with updated contentSeenCount '
          'when contentSeenCount is passed', () {
        const contentSeenCount = 10;
        expect(
          ArticleState(status: ArticleStatus.populated).copyWith(
            contentSeenCount: contentSeenCount,
          ),
          equals(
            ArticleState(
              status: ArticleStatus.populated,
              contentSeenCount: contentSeenCount,
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
