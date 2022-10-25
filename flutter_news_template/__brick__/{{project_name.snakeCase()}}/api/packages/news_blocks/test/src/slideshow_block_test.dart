// ignore_for_file: prefer_const_constructors
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SlideshowBlock', () {
    test('can be (de)serialized', () {
      final slide = SlideBlock(
        imageUrl: 'imageUrl',
        caption: 'caption',
        photoCredit: 'photoCredit',
        description: 'description',
      );
      final block = SlideshowBlock(title: 'title', slides: [slide, slide]);

      expect(
        SlideshowBlock.fromJson(block.toJson()),
        equals(block),
      );
    });
  });
}
