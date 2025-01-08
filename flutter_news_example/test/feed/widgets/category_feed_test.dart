// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockGoRouter extends Mock implements GoRouter {}

const networkErrorButtonText = 'Try Again';

void main() {
  late FeedBloc feedBloc;

  const category = Category(id: 'top', name: 'Top');
  final feed = <String, List<NewsBlock>>{
    category.id: [
      DividerHorizontalBlock(),
      SpacerBlock(spacing: Spacing.medium),
    ],
  };

  setUp(() {
    feedBloc = MockFeedBloc();
    when(() => feedBloc.state).thenReturn(
      FeedState(feed: feed, status: FeedStatus.populated),
    );
    registerFallbackValue(FeedRefreshRequested(category: category));
  });

  group('CategoryFeed', () {
    group('when FeedStatus is failure and feed is populated', () {
      setUpAll(() {
        registerFallbackValue(category);
      });

      setUp(() {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(feed: feed, status: FeedStatus.failure),
          ]),
        );
      });

      testWidgets('shows NetworkErrorAlert', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        expect(
          find.byType(NetworkError),
          findsOneWidget,
        );
      });

      testWidgets('requests feed refresh on NetworkErrorAlert press',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        await tester.ensureVisible(find.text(networkErrorButtonText));

        await tester.tap(find.textContaining(networkErrorButtonText));

        verify(() => feedBloc.add(any(that: isA<FeedRefreshRequested>())))
            .called(1);
      });

      testWidgets('renders a SelectionArea', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        expect(find.byType(SelectionArea), findsOneWidget);
      });

      testWidgets('shows CategoryFeedItem for each feed block', (tester) async {
        final categoryFeed = feed[category.id]!;

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        expect(
          find.byType(CategoryFeedItem),
          findsNWidgets(categoryFeed.length),
        );

        for (final block in categoryFeed) {
          expect(
            find.byWidgetPredicate(
              (widget) => widget is CategoryFeedItem && widget.block == block,
            ),
            findsOneWidget,
          );
        }
      });
    });

    group('when FeedStatus is failure and feed is unpopulated', () {
      late GoRouter goRouter;
      setUpAll(() {
        goRouter = MockGoRouter();
        registerFallbackValue(category);
      });

      setUp(() {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(feed: {}, status: FeedStatus.failure),
          ]),
        );

        when(
          () => goRouter.pushNamed(
            NetworkErrorPage.routePath,
          ),
        ).thenAnswer((_) async {
          return null;
        });
      });

      Future<void> pumpWidget(WidgetTester tester, Widget child) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: InheritedGoRouter(
              goRouter: goRouter,
              child: child,
            ),
          ),
        );
      }

      testWidgets('navigates to Network Error page and requests feed again',
          (tester) async {
        await pumpWidget(tester, CategoryFeed(category: category));

        verify(
          () => goRouter.pushNamed(
            NetworkErrorPage.routePath,
          ),
        ).called(1);

        verify(
          () => feedBloc.add(FeedRequested(category: category)),
        ).called(2);
      });
    });

    group('when FeedStatus is populated', () {
      setUp(() {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(status: FeedStatus.populated, feed: feed),
          ]),
        );
      });

      testWidgets('shows CategoryFeedItem for each feed block', (tester) async {
        final categoryFeed = feed[category.id]!;

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        expect(
          find.byType(CategoryFeedItem),
          findsNWidgets(categoryFeed.length),
        );

        for (final block in categoryFeed) {
          expect(
            find.byWidgetPredicate(
              (widget) => widget is CategoryFeedItem && widget.block == block,
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets('refreshes on pull to refresh', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        await tester.fling(
          find.byType(CategoryFeed),
          const Offset(0, 300),
          1000,
        );

        await tester.pump();

        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        verify(
          () => feedBloc.add(any(that: isA<FeedRefreshRequested>())),
        ).called(1);
      });
    });

    group('CategoryFeedLoaderItem', () {
      final hasMoreNews = <String, bool>{
        category.id: true,
      };

      group('is shown', () {
        testWidgets('when FeedStatus is initial', (tester) async {
          whenListen(
            feedBloc,
            Stream.fromIterable([
              FeedState.initial(),
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: feedBloc,
              child: CategoryFeed(category: category),
            ),
          );

          expect(find.byType(CategoryFeedLoaderItem), findsOneWidget);
        });

        testWidgets('when FeedStatus is loading', (tester) async {
          whenListen(
            feedBloc,
            Stream.fromIterable([
              FeedState(status: FeedStatus.loading),
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: feedBloc,
              child: CategoryFeed(category: category),
            ),
          );

          expect(find.byType(CategoryFeedLoaderItem), findsOneWidget);
        });

        testWidgets(
            'when FeedStatus is populated and '
            'hasMoreNews is true', (tester) async {
          whenListen(
            feedBloc,
            Stream.fromIterable([
              FeedState.initial(),
              FeedState(
                status: FeedStatus.populated,
                feed: feed,
                hasMoreNews: hasMoreNews,
              ),
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: feedBloc,
              child: CategoryFeed(category: category),
            ),
          );

          expect(find.byType(CategoryFeedLoaderItem), findsOneWidget);
        });
      });

      testWidgets(
          'is not shown '
          'when FeedStatus is populated and '
          'hasMoreNews is false', (tester) async {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(
              status: FeedStatus.populated,
              feed: feed,
              hasMoreNews: {
                category.id: false,
              },
            ),
          ]),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        expect(find.byType(CategoryFeedLoaderItem), findsNothing);
      });

      testWidgets('adds FeedRequested to FeedBloc', (tester) async {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(
              status: FeedStatus.populated,
              feed: feed,
              hasMoreNews: hasMoreNews,
            ),
          ]),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
        );

        verify(
          () => feedBloc.add(FeedRequested(category: category)),
        ).called(1);
      });
    });
  });
}
