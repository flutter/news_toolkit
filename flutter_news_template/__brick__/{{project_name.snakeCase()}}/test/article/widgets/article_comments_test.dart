// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

void main() {
  group('ArticleComments', () {
    testWidgets('renders title and text field', (tester) async {
      await tester.pumpApp(ArticleComments());

      expect(
        find.byKey(Key('articleComments_discussionTitle')),
        findsOneWidget,
      );
      expect(
        find.byType(AppTextField),
        findsOneWidget,
      );
    });

    testWidgets(
        'adds ArticleCommented with article title to ArticleBloc '
        'when comment is submitted', (tester) async {
      final ArticleBloc articleBloc = MockArticleBloc();
      final articleState = ArticleState.initial().copyWith(title: 'title');
      when(() => articleBloc.state).thenReturn(articleState);

      await tester.pumpApp(
        BlocProvider.value(
          value: articleBloc,
          child: ArticleComments(),
        ),
      );

      final textField = tester.widget<AppTextField>(find.byType(AppTextField));
      textField.onSubmitted!('');

      verify(
        () => articleBloc.add(
          ArticleCommented(articleTitle: articleState.title!),
        ),
      ).called(1);
    });
  });
}
