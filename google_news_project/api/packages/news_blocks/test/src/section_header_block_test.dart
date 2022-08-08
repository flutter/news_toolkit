// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SectionHeaderBlock', () {
    test('can be (de)serialized', () {
      final action = NavigateToFeedCategoryAction(category: Category.top);
      final block = SectionHeaderBlock(title: 'example_title', action: action);
      expect(SectionHeaderBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
