// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('TextParagraphBlock', () {
    test('can be (de)serialized', () {
      final block = TextParagraphBlock(text: 'Paragraph text');

      expect(TextParagraphBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
