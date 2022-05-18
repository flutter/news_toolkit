// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('VideoIntroductionBlock', () {
    test('can be (de)serialized', () {
      final block = VideoIntroductionBlock(
        category: PostCategory.technology,
        title: 'title',
        videoUrl: 'videoUrl',
      );

      expect(VideoIntroductionBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
