// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

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
  });

  group('CategoryFeed', () {
    testWidgets(
        'shows CircularProgressIndicator '
        'when FeedStatus is initial', (tester) async {
      when(() => feedBloc.state).thenReturn(
        FeedState(status: FeedStatus.initial),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: feedBloc,
          child: CustomScrollView(
            slivers: [CategoryFeed(category: category)],
          ),
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });

    testWidgets(
        'shows CircularProgressIndicator '
        'when FeedStatus is loading', (tester) async {
      when(() => feedBloc.state).thenReturn(
        FeedState(status: FeedStatus.loading),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: feedBloc,
          child: CustomScrollView(
            slivers: [CategoryFeed(category: category)],
          ),
        ),
      );

      expect(
        find.byType(CircularProgressIndicator),
        findsOneWidget,
      );
    });

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

      testWidgets(
          'shows SnackBar with error message '
          'when FeedStatus is failure', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CustomScrollView(
              slivers: [CategoryFeed(category: category)],
            ),
          ),
        );

        expect(
          find.byKey(const Key('categoryFeed_failure_snackBar')),
          findsOneWidget,
        );
      });

      testWidgets('shows CategoryFeedItem for each feed block', (tester) async {
        final categoryFeed = feed[category]!;

        await tester.pumpApp(
          BlocProvider.value(
            value: feedBloc,
            child: CustomScrollView(
              slivers: [CategoryFeed(category: category)],
            ),
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
            child: CustomScrollView(
              slivers: [CategoryFeed(category: category)],
            ),
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

      group('CategoryFeedLoaderItem', () {
        final hasMoreNews = <Category, bool>{
          Category.top: true,
        };

        testWidgets('is shown when hasMoreNews is true', (tester) async {
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
              child: CustomScrollView(
                slivers: [CategoryFeed(category: category)],
              ),
            ),
          );

          expect(find.byType(CategoryFeedLoaderItem), findsOneWidget);
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
              child: CustomScrollView(
                slivers: [CategoryFeed(category: category)],
              ),
            ),
          );

          verify(
            () => feedBloc.add(FeedRequested(category: category)),
          ).called(1);
        });

        testWidgets('is not shown when hasMoreNews is false', (tester) async {
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
              child: CustomScrollView(
                slivers: [CategoryFeed(category: category)],
              ),
            ),
          );

          expect(find.byType(CategoryFeedLoaderItem), findsNothing);
        });
      });
    });
  });
}
