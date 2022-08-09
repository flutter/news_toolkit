// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SpacerBlock', () {
    test('can be (de)serialized', () {
      final block = SpacerBlock(spacing: Spacing.medium);

      expect(SpacerBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
