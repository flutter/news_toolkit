// ignore_for_file: prefer_const_constructors

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('BannerAdBlock', () {
    test('can be (de)serialized', () {
      final block = BannerAdBlock(size: BannerAdSize.normal);
      expect(BannerAdBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
