// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/src/text_caption_block.dart';
import 'package:test/test.dart';

void main() {
  group('TextCaptionBlock', () {
    test('can be (de)serialized', () {
      final block = TextCaptionBlock(
        weight: TextCaptionWeight.normal,
        text: 'Text caption',
      );

      expect(TextCaptionBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
