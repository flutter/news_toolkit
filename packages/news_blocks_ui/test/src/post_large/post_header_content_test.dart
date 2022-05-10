import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/post_large/post_content.dart';
import 'package:news_blocks_ui/src/post_large/post_content_category.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PostHeaderContent', () {
    final publishedAt = DateTime(2000, 12, 31);
    const premiumText = 'Premium';
    const title = 'Title';
    const author = 'Author';
    const description = 'Description';

    testWidgets('renders without category', (tester) async {
      final testPostHeaderContent = PostContent(
        publishedAt: publishedAt,
        premiumText: premiumText,
        title: title,
        author: author,
        description: description,
      );

      await tester.pumpContentThemedApp(testPostHeaderContent);

      expect(find.byType(PostContentCategory), findsNothing);
    });

    testWidgets('calls onShare when clicked on share icon', (tester) async {
      final completer = Completer<void>();
      final testPostHeaderContent = PostContent(
        publishedAt: publishedAt,
        premiumText: premiumText,
        title: title,
        author: author,
        description: description,
        categoryName: 'Category',
        onShare: completer.complete,
      );

      await tester.pumpContentThemedApp(testPostHeaderContent);

      await tester.tap(find.byType(IconButton));

      expect(completer.isCompleted, isTrue);
    });
  });
}
