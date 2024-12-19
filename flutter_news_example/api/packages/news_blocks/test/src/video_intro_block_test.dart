// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('VideoIntroductionBlock', () {
    test('can be (de)serialized', () {
      const category = Category(id: 'technology', name: 'Technology');
      final block = VideoIntroductionBlock(
        categoryId: category.id,
        title: 'title',
        videoUrl: 'videoUrl',
      );

      expect(VideoIntroductionBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
