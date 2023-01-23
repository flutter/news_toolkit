// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

const networkErrorButtonText = 'Try Again';

void main() {
  late FeedBloc feedBloc;

  const category = Category.top;
  final feed = <Category, List<NewsBlock>>{
    Category.top: [
      DividerHorizontalBlock(),
      SpacerBlock(spacing: Spacing.medium),
    ]
  };

  setUp(() {
    feedBloc = MockFeedBloc();
    when(() => feedBloc.state).thenReturn(
      FeedState(feed: feed, status: FeedStatus.populated),
    );
    registerFallbackValue(FeedRefreshRequested(category: Category.business));
  });

  group('CategoryFeed', () {
    group('when FeedStatus is failure and feed is populated', () {
      setUpAll(() {
        registerFallbackValue(Category.top);
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
        final categoryFeed = feed[category]!;

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
      setUpAll(() {
        registerFallbackValue(Category.top);
        registerFallbackValue(NetworkError.route());
      });

      setUp(() {
        whenListen(
          feedBloc,
          Stream.fromIterable([
            FeedState.initial(),
            FeedState(feed: {}, status: FeedStatus.failure),
          ]),
        );
      });

      testWidgets('pushes NetworkErrorAlert on Scaffold', (tester) async {
        final navigatorObserver = MockNavigatorObserver();

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
          navigatorObserver: navigatorObserver,
        );

        verify(() => navigatorObserver.didPush(any(), any()));

        expect(
          find.ancestor(
            of: find.byType(NetworkError),
            matching: find.byType(Scaffold),
          ),
          findsOneWidget,
        );
      });

      testWidgets('requests feed refresh on NetworkErrorAlert press',
          (tester) async {
        final navigatorObserver = MockNavigatorObserver();

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CategoryFeed(category: category),
          ),
          navigatorObserver: navigatorObserver,
        );

        verify(() => navigatorObserver.didPush(any(), any()));

        await tester.ensureVisible(find.text(networkErrorButtonText));

        await tester.pump(Duration(seconds: 1));
        await tester.tap(find.textContaining(networkErrorButtonText));

        verify(() => feedBloc.add(any(that: isA<FeedRefreshRequested>())))
            .called(1);
        verify(() => navigatorObserver.didPop(any(), any()));
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
        final categoryFeed = feed[category]!;

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
      final hasMoreNews = <Category, bool>{
        Category.top: true,
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
              )
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
                category: false,
              },
            )
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
            )
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
