// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

const networkErrorButtonText = 'Try Again';

void main() {
  late ArticleBloc articleBloc;

  final content = <NewsBlock>[
    DividerHorizontalBlock(),
    SpacerBlock(spacing: Spacing.medium),
    TextParagraphBlock(text: 'text'),
    ImageBlock(imageUrl: 'imageUrl'),
  ];

  setUp(() {
    articleBloc = MockArticleBloc();
    when(() => articleBloc.state).thenReturn(
      ArticleState(content: content, status: ArticleStatus.populated),
    );

    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('ArticleContent', () {
    testWidgets('renders StickyAd', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleContent(),
        ),
      );

      expect(find.byType(StickyAd), findsOneWidget);
    });

    group('when ArticleStatus is failure and content is present', () {
      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(content: content, status: ArticleStatus.failure),
          ]),
        );
      });

      testWidgets('shows NetworkErrorAlert', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        expect(
          find.byType(NetworkError),
          findsOneWidget,
        );
      });

      testWidgets('shows ArticleContentItem for each content block',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        for (final block in content) {
          expect(
            find.byWidgetPredicate(
              (widget) => widget is ArticleContentItem && widget.block == block,
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets('NetworkErrorAlert requests article on press',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        expect(
          find.text(networkErrorButtonText),
          findsOneWidget,
        );

        await tester.ensureVisible(find.textContaining(networkErrorButtonText));

        await tester.pump(Duration(milliseconds: 100));
        await tester.tap(find.textContaining(networkErrorButtonText));

        verify(() => articleBloc.add(ArticleRequested())).called(2);
      });
    });

    group('when ArticleStatus is failure and content is absent', () {
      setUpAll(() {
        registerFallbackValue(
          NetworkError.route(
            errorText: 'errorText',
            refreshButtonText: 'refreshButtonText',
          ),
        );
      });

      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(content: [], status: ArticleStatus.failure),
          ]),
        );
      });

      testWidgets('pushes NetworkErrorAlert on Scaffold', (tester) async {
        final navigatorObserver = MockNavigatorObserver();

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
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

      testWidgets('NetworkErrorAlert requests article on press',
          (tester) async {
        final navigatorObserver = MockNavigatorObserver();

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
          navigatorObserver: navigatorObserver,
        );

        verify(() => navigatorObserver.didPush(any(), any()));

        expect(
          find.text(networkErrorButtonText),
          findsOneWidget,
        );

        await tester.ensureVisible(find.textContaining(networkErrorButtonText));

        await tester.pump(Duration(milliseconds: 100));
        await tester.tap(find.textContaining(networkErrorButtonText).last);
        await tester.pump(Duration(milliseconds: 100));

        verify(() => articleBloc.add(ArticleRequested())).called(2);
        verify(() => navigatorObserver.didPop(any(), any()));
      });
    });

    group('when ArticleStatus is shareFailure', () {
      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(content: content, status: ArticleStatus.shareFailure),
          ]),
        );
      });

      testWidgets('shows SnackBar with error message', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        expect(
          find.byKey(const Key('articleContent_shareFailure_snackBar')),
          findsOneWidget,
        );
      });
    });

    group('when ArticleStatus is populated', () {
      final uri = Uri(path: 'notEmptyUrl');
      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(
              status: ArticleStatus.populated,
              content: content,
              uri: uri,
            ),
          ]),
        );
      });

      testWidgets('shows ArticleContentItem for each content block',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        for (final block in content) {
          expect(
            find.byWidgetPredicate(
              (widget) => widget is ArticleContentItem && widget.block == block,
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets(
          'adds ShareRequested to ArticleBloc '
          'when ArticleContentItem onSharePressed is called', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        final articleItem = find.byType(ArticleContentItem).first;
        tester.widget<ArticleContentItem>(articleItem).onSharePressed?.call();

        verify(() => articleBloc.add(ShareRequested(uri: uri))).called(1);
      });

      testWidgets(
          'adds ArticleContentSeen to ArticleBloc '
          'for every visible content block', (tester) async {
        final longContent = <NewsBlock>[
          DividerHorizontalBlock(),
          SpacerBlock(spacing: Spacing.medium),
          TextParagraphBlock(text: 'text'),
          ImageBlock(imageUrl: 'imageUrl'),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          SpacerBlock(spacing: Spacing.extraLarge),
          TextLeadParagraphBlock(text: 'text'),
        ];

        final state =
            ArticleState(content: longContent, status: ArticleStatus.populated);

        whenListen(
          articleBloc,
          Stream.value(state),
          initialState: state,
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        await tester.pump();

        verifyNever(
          () => articleBloc
              .add(ArticleContentSeen(contentIndex: longContent.length - 1)),
        );

        await tester.dragUntilVisible(
          find.byWidgetPredicate(
            (widget) =>
                widget is ArticleContentItem &&
                widget.block == longContent.last,
          ),
          find.byType(ArticleContent),
          Offset(0, -50),
          duration: Duration.zero,
        );

        await tester.pump();

        for (var index = 0; index < longContent.length; index++) {
          verify(
            () => articleBloc.add(ArticleContentSeen(contentIndex: index)),
          ).called(isNonZero);
        }
      });

      testWidgets(
          'adds TrackAnalyticsEvent to AnalyticsBloc '
          'with ArticleMilestoneEvent '
          'when contentMilestone changes', (tester) async {
        final analyticsBloc = MockAnalyticsBloc();
        final initialState = ArticleState.initial().copyWith(title: 'title');
        final states = [
          initialState.copyWith(contentSeenCount: 3, contentTotalCount: 10),
          initialState.copyWith(contentSeenCount: 5, contentTotalCount: 10),
          initialState.copyWith(contentSeenCount: 10, contentTotalCount: 10),
        ];

        whenListen(
          articleBloc,
          Stream.fromIterable(states),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
          analyticsBloc: analyticsBloc,
        );

        for (final state in states) {
          verify(
            () => analyticsBloc.add(
              TrackAnalyticsEvent(
                ArticleMilestoneEvent(
                  articleTitle: state.title!,
                  milestonePercentage: state.contentMilestone,
                ),
              ),
            ),
          ).called(1);
        }
      });
    });

    group('ArticleContentLoaderItem', () {
      group('is shown', () {
        testWidgets('when ArticleStatus is initial', (tester) async {
          whenListen(
            articleBloc,
            Stream.fromIterable([
              ArticleState.initial(),
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: articleBloc,
              child: ArticleContent(),
            ),
          );

          expect(
            find.byKey(Key('articleContent_empty_loaderItem')),
            findsOneWidget,
          );
        });

        testWidgets('when ArticleStatus is loading', (tester) async {
          whenListen(
            articleBloc,
            Stream.fromIterable([
              ArticleState(status: ArticleStatus.loading),
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: articleBloc,
              child: ArticleContent(),
            ),
          );

          expect(
            find.byKey(Key('articleContent_moreContent_loaderItem')),
            findsOneWidget,
          );
        });

        testWidgets(
            'when ArticleStatus is populated '
            'and hasMoreContent is true', (tester) async {
          whenListen(
            articleBloc,
            Stream.fromIterable([
              ArticleState.initial(),
              ArticleState(
                status: ArticleStatus.populated,
                content: content,
                hasMoreContent: true,
              )
            ]),
          );

          await tester.pumpApp(
            BlocProvider.value(
              value: articleBloc,
              child: ArticleContent(),
            ),
          );

          expect(
            find.byKey(Key('articleContent_moreContent_loaderItem')),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          'is not shown and ArticleTrailingContent is shown '
          'when ArticleStatus is populated '
          'and hasMoreContent is false', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(
              status: ArticleStatus.populated,
              content: content,
              hasMoreContent: false,
            )
          ]),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        expect(find.byType(ArticleContentLoaderItem), findsNothing);
        expect(find.byType(ArticleTrailingContent), findsOneWidget);
      });

      testWidgets('adds ArticleRequested to ArticleBloc', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(
              status: ArticleStatus.populated,
              content: content,
              hasMoreContent: true,
            )
          ]),
          initialState: ArticleState.initial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        verify(() => articleBloc.add(ArticleRequested())).called(1);
      });

      testWidgets(
          'does not add ArticleRequested to ArticleBloc '
          'when ArticleStatus is loading', (tester) async {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(
              status: ArticleStatus.loading,
              content: content,
              hasMoreContent: true,
            )
          ]),
          initialState: ArticleState.initial(),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        verifyNever(() => articleBloc.add(ArticleRequested()));
      });
    });
  });
}
