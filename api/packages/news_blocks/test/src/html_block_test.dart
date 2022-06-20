// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/src/html_block.dart';
import 'package:test/test.dart';

void main() {
  group('HtmlBlock', () {
    test('can be (de)serialized', () {
      final block = HtmlBlock(content: '<p>hello world</p>');

      expect(HtmlBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
