// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/article/article.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ArticleComments', () {
    testWidgets('renders ArticlesComments', (tester) async {
      await tester.pumpApp(
        ArticleComments(),
      );

      expect(
        find.byKey(Key('__discussion_text__')),
        findsOneWidget,
      );
      expect(
        find.byType(AppTextField),
        findsOneWidget,
      );
    });
  });
}
