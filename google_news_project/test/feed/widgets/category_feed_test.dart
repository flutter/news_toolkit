// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

import '../../helpers/helpers.dart';

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

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
    group('when FeedStatus is failure', () {
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
          find.byType(NetworkErrorAlert),
          findsOneWidget,
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
          find.byType(CategoryFeedItem).last,
          const Offset(0, 300),
          1000,
        );

        await tester.pump();

        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));

        verify(() => feedBloc.add(any(that: isA<FeedRefreshRequested>())))
            .called(1);
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
