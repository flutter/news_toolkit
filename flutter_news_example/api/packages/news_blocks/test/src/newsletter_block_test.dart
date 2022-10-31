import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('NewsletterBlock', () {
    test('can be (de)serialized', () {
      const block = NewsletterBlock();

      expect(NewsletterBlock.fromJson(block.toJson()), equals(block));
    });
  });
}
