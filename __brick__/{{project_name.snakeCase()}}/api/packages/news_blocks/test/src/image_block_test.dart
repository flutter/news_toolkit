// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('ImageBlock', () {
    test('can be (de)serialized', () {
      final block = ImageBlock(imageUrl: 'imageUrl');
      expect(ImageBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
