// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:article_repository/article_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/newsletter/newsletter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

void main() {
  initMockHydratedStorage();

  group('CategoryFeedItem', () {
    late ArticleRepository articleRepository;

    setUp(() {
      articleRepository = MockArticleRepository();

      when(articleRepository.incrementArticleViews).thenAnswer((_) async {});
      when(articleRepository.resetArticleViews).thenAnswer((_) async {});
      when(articleRepository.fetchArticleViews)
          .thenAnswer((_) async => ArticleViews(0, null));

      when(
        () => articleRepository.getArticle(
          id: any(named: 'id'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => ArticleResponse(
          title: 'title',
          content: [],
          totalCount: 0,
          url: Uri.parse('https://www.dglobe.com/'),
          isPremium: false,
          isPreview: false,
        ),
      );
      when(
        () => articleRepository.getRelatedArticles(
          id: any(named: 'id'),
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer(
        (_) async => RelatedArticlesResponse(
          relatedArticles: [],
          totalCount: 0,
        ),
      );
    });

    testWidgets(
        'renders DividerHorizontal '
        'for DividerHorizontalBlock', (tester) async {
      const block = DividerHorizontalBlock();
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is DividerHorizontal && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Spacer '
        'for SpacerBlock', (tester) async {
      const block = SpacerBlock(spacing: Spacing.large);
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Spacer && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders SectionHeader '
        'for SectionHeaderBlock', (tester) async {
      const block = SectionHeaderBlock(title: 'title');
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SectionHeader && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostLarge '
        'for PostLargeBlock', (tester) async {
      const category = Category(id: 'technology', name: 'Technology');
      final block = PostLargeBlock(
        id: 'id',
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 9),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          CustomScrollView(
            slivers: [CategoryFeedItem(block: block)],
          ),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostLarge && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostMedium '
        'for PostMediumBlock', (tester) async {
      const category = Category(id: 'sports', name: 'Sports');
      final block = PostMediumBlock(
        id: 'id',
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 10),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostMedium && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostSmall '
        'for PostSmallBlock', (tester) async {
      const category = Category(id: 'health', name: 'Health');
      final block = PostSmallBlock(
        id: 'id',
        categoryId: category.id,
        author: 'author',
        publishedAt: DateTime(2022, 3, 11),
        imageUrl: 'imageUrl',
        title: 'title',
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostSmall && widget.block == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders PostGrid '
        'for PostGridGroupBlock', (tester) async {
      const category = Category(id: 'science', name: 'Science');
      final block = PostGridGroupBlock(
        categoryId: category.id,
        tiles: [
          PostGridTileBlock(
            id: 'id',
            categoryId: category.id,
            author: 'author',
            publishedAt: DateTime(2022, 3, 12),
            imageUrl: 'imageUrl',
            title: 'title',
          ),
        ],
      );
      await mockNetworkImages(() async {
        await tester.pumpApp(
          CustomScrollView(
            slivers: [CategoryFeedItem(block: block)],
          ),
        );
      });
      expect(
        find.byWidgetPredicate(
          (widget) => widget is PostGrid && widget.gridGroupBlock == block,
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders Newsletter '
        'for NewsletterBlock', (tester) async {
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
      final block = NewsletterBlock();
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );
      expect(find.byType(Newsletter), findsOneWidget);
    });

    testWidgets(
        'renders BannerAd '
        'for BannerAdBlock', (tester) async {
      final block = BannerAdBlock(size: BannerAdSize.normal);
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );
      expect(find.byType(BannerAd), findsOneWidget);
    });

    testWidgets(
        'renders SizedBox '
        'for unsupported block', (tester) async {
      final block = UnknownBlock();
      await tester.pumpApp(
        CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
      );

      expect(find.byType(SizedBox), findsNothing);
    });

    group(
        'navigates to ArticlePage '
        'on NavigateToArticleAction', () {
      const articleId = 'articleId';

      testWidgets('from PostLarge', (tester) async {
        const category = Category(id: 'technology', name: 'Technology');
        final block = PostLargeBlock(
          id: articleId,
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
          isContentOverlaid: true,
          action: NavigateToArticleAction(articleId: articleId),
        );

        await tester.pumpApp(
          CustomScrollView(
            slivers: [CategoryFeedItem(block: block)],
          ),
          articleRepository: articleRepository,
        );

        await tester.ensureVisible(find.byType(PostLarge));
        await tester.tap(find.byType(PostLarge));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) => widget is ArticlePage && widget.id == articleId,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostMedium', (tester) async {
        const category = Category(id: 'sports', name: 'Sports');
        final block = PostMediumBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 10),
          imageUrl: 'imageUrl',
          title: 'title',
          isContentOverlaid: true,
          action: NavigateToArticleAction(articleId: articleId),
        );

        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        await tester.ensureVisible(find.byType(PostMedium));
        await tester.tap(find.byType(PostMedium));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) => widget is ArticlePage && widget.id == articleId,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostSmall', (tester) async {
        const category = Category(id: 'health', name: 'Health');
        final block = PostSmallBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
          action: NavigateToArticleAction(articleId: articleId),
        );
        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        await tester.ensureVisible(find.byType(PostSmallContent));
        await tester.tap(find.byType(PostSmallContent));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) => widget is ArticlePage && widget.id == articleId,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostGrid', (tester) async {
        const category = Category(id: 'science', name: 'Science');
        final block = PostGridGroupBlock(
          categoryId: category.id,
          tiles: [
            PostGridTileBlock(
              id: 'id',
              categoryId: category.id,
              author: 'author',
              publishedAt: DateTime(2022, 3, 12),
              imageUrl: 'imageUrl',
              title: 'title',
              action: NavigateToArticleAction(articleId: articleId),
            ),
          ],
        );

        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        // We're tapping on a PostLarge as the first post of the PostGrid
        // is displayed as a large post.
        await tester.ensureVisible(find.byType(PostLarge));
        await tester.tap(find.byType(PostLarge));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) => widget is ArticlePage && widget.id == articleId,
          ),
          findsOneWidget,
        );
      });
    });

    group(
        'navigates to video ArticlePage '
        'on NavigateToVideoArticleAction', () {
      const articleId = 'articleId';

      testWidgets('from PostLarge', (tester) async {
        const category = Category(id: 'technology', name: 'Technology');
        final block = PostLargeBlock(
          id: articleId,
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
          isContentOverlaid: true,
          action: NavigateToVideoArticleAction(articleId: articleId),
        );

        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        await tester.ensureVisible(find.byType(PostLarge));
        await tester.tap(find.byType(PostLarge));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is ArticlePage &&
                widget.id == articleId &&
                widget.isVideoArticle == true,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostMedium', (tester) async {
        const category = Category(id: 'sports', name: 'Sports');
        final block = PostMediumBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 10),
          imageUrl: 'imageUrl',
          title: 'title',
          isContentOverlaid: true,
          action: NavigateToVideoArticleAction(articleId: articleId),
        );

        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        await tester.ensureVisible(find.byType(PostMedium));
        await tester.tap(find.byType(PostMedium));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is ArticlePage &&
                widget.id == articleId &&
                widget.isVideoArticle == true,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostSmall', (tester) async {
        const category = Category(id: 'health', name: 'Health');
        final block = PostSmallBlock(
          id: 'id',
          categoryId: category.id,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
          action: NavigateToVideoArticleAction(articleId: articleId),
        );

        await mockNetworkImages(() async {
          await tester.pumpApp(
            CustomScrollView(
              slivers: [CategoryFeedItem(block: block)],
            ),
            articleRepository: articleRepository,
          );
        });

        await tester.ensureVisible(find.byType(PostSmallContent));
        await tester.tap(find.byType(PostSmallContent));
        await tester.pumpAndSettle();

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is ArticlePage &&
                widget.id == articleId &&
                widget.isVideoArticle == true,
          ),
          findsOneWidget,
        );
      });

      testWidgets('from PostGrid', (tester) async {
        const category = Category(id: 'science', name: 'Science');
        final block = PostGridGroupBlock(
          categoryId: category.id,
          tiles: [
            PostGridTileBlock(
              id: 'id',
              categoryId: category.id,
              author: 'author',
              publishedAt: DateTime(2022, 3, 12),
              imageUrl: 'imageUrl',
              title: 'title',
              action: NavigateToVideoArticleAction(articleId: articleId),
            ),
          ],
        );

        await tester.pumpApp(
          CustomScrollView(
            slivers: [CategoryFeedItem(block: block)],
          ),
        );

        // We're tapping on a PostLarge as the first post of the PostGrid
        // is displayed as a large post.

        await tester.ensureVisible(find.byType(PostLarge));
        await tester.tap(find.byType(PostLarge));

        await tester.pump();
        await tester.pump(kThemeAnimationDuration);

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is ArticlePage &&
                widget.id == articleId &&
                widget.isVideoArticle == true,
          ),
          findsOneWidget,
        );
      });
    });

    testWidgets(
        'adds CategorySelected to CategoriesBloc '
        'on NavigateToFeedCategoryAction', (tester) async {
      final categoriesBloc = MockCategoriesBloc();

      const category = Category(id: 'top', name: 'Top');
      const block = SectionHeaderBlock(
        title: 'title',
        action: NavigateToFeedCategoryAction(category: category),
      );

      await tester.pumpApp(
        BlocProvider<CategoriesBloc>.value(
          value: categoriesBloc,
          child: CustomScrollView(slivers: [CategoryFeedItem(block: block)]),
        ),
      );

      await tester.ensureVisible(find.byType(IconButton));
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      verify(() => categoriesBloc.add(CategorySelected(category: category)))
          .called(1);
    });
  });
}
