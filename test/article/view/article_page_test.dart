// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

void main() {
  group('ArticlePage', () {
    test('has a route', () {
      expect(ArticlePage.route(id: 'id'), isA<MaterialPageRoute>());
    });

    testWidgets('renders ArticleView', (tester) async {
      await tester.pumpApp(ArticlePage(id: 'id'));
      expect(find.byType(ArticleView), findsOneWidget);
    });

    testWidgets('provides ArticleBloc', (tester) async {
      await tester.pumpApp(ArticlePage(id: 'id'));
      final BuildContext viewContext = tester.element(find.byType(ArticleView));
      expect(viewContext.read<ArticleBloc>(), isNotNull);
    });
  });

  group('ArticleView', () {
    late ArticleBloc articleBloc;

    setUp(() {
      articleBloc = MockArticleBloc();

      when(() => articleBloc.state).thenReturn(ArticleState.initial());
    });

    testWidgets('renders ArticleContent', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleView(),
        ),
      );
      expect(find.byType(ArticleContent), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when back button is pressed', (tester) async {
        final navigator = MockNavigator();
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          BlocProvider.value(
            value: articleBloc,
            child: ArticleView(),
          ),
          navigator: navigator,
        );
        await tester.tap(find.byType(AppBackButton));
        await tester.pump();
        verify(navigator.pop).called(1);
      });
    });
  });
}
