// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('VideoIntroBlock', () {
    test('can be (de)serialized', () {
      final block = VideoIntroBlock(
        category: PostCategory.technology,
        title: 'title',
        videoUrl: 'videoUrl',
      );

      expect(VideoIntroBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
