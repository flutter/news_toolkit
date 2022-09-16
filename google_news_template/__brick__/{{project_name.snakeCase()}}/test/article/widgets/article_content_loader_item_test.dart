// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ArticleContentLoaderItem', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpApp(ArticleContentLoaderItem());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('executes onPresented callback', (tester) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        ArticleContentLoaderItem(onPresented: completer.complete),
      );

      expect(completer.isCompleted, isTrue);
    });
  });
}
