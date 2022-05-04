// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/src/divider_horizontal_block.dart';
import 'package:test/test.dart';

void main() {
  group('DividerHorizontalBlock', () {
    test('can be (de)serialized', () {
      final block = DividerHorizontalBlock(subheader: 'example_subheader');

      expect(DividerHorizontalBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
