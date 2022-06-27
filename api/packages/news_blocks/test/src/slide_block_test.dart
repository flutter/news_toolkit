// ignore_for_file: prefer_const_constructors
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SlideBlock', () {
    test('can be (de)serialized', () {
      final block = SlideBlock(
        caption: 'caption',
        description: 'description',
        photoCredit: 'photoCredit',
        imageUrl: 'imageUrl',
      );

      expect(
        SlideBlock.fromJson(block.toJson()),
        equals(block),
      );
    });
  });
}
