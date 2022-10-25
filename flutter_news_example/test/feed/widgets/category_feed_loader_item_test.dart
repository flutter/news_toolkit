// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/feed/feed.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CategoryFeedLoaderItem', () {
    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpApp(CategoryFeedLoaderItem());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('executes onPresented callback', (tester) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        CategoryFeedLoaderItem(onPresented: completer.complete),
      );

      expect(completer.isCompleted, isTrue);
    });
  });
}
