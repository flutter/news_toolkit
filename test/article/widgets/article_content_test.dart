// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

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

    group('when ArticleStatus is failure', () {
      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(content: content, status: ArticleStatus.failure),
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
          find.byKey(const Key('articleContent_failure_snackBar')),
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
    });

    group('when ArticleStatus is populated', () {
      setUp(() {
        whenListen(
          articleBloc,
          Stream.fromIterable([
            ArticleState.initial(),
            ArticleState(status: ArticleStatus.populated, content: content),
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
            find.byKey(Key('articleContent_empty_loaderItem')),
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

          expect(find.byType(ArticleContentLoaderItem), findsOneWidget);
        });
      });

      testWidgets(
          'is not shown '
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
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleContent(),
          ),
        );

        verify(() => articleBloc.add(ArticleRequested())).called(1);
      });
    });
  });
}
