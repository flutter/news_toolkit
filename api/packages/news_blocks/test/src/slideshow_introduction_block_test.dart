// ignore_for_file: prefer_const_constructors
import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('SlideshowIntroductionBlock', () {
    test('can be (de)serialized', () {
      final block = SlideshowIntroductionBlock(
        title: 'title',
        coverImageUrl: 'coverImageUrl',
      );

      expect(
        SlideshowIntroductionBlock.fromJson(block.toJson()),
        equals(block),
      );
    });
  });
}
