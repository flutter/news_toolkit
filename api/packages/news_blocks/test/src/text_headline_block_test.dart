// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TextHeadlineBlock', () {
    test('can be (de)serialized', () {
      final block = TextHeadlineBlock(text: 'Title');

      expect(TextHeadlineBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
