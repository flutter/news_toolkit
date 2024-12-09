// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('BlockActionConverter', () {
    test('can (de)serialize BlockAction', () {
      final converter = BlockActionConverter();
      const category = Category(id: 'sports', name: 'Sports');

      const actions = <BlockAction>[
        NavigateToArticleAction(articleId: 'articleId'),
        NavigateToFeedCategoryAction(category: category),
      ];

      for (final action in actions) {
        expect(
          converter.fromJson(converter.toJson(action)),
          equals(action),
        );
      }
    });
  });
}
