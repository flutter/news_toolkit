import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group('Category', () {
    group('fromString', () {
      test('returns business', () {
        expect(
          Category.fromString('business'),
          equals(Category.business),
        );
      });

      test('returns business', () {
        expect(
          Category.fromString('entertainment'),
          equals(Category.entertainment),
        );
      });

      test('returns top', () {
        expect(
          Category.fromString('top'),
          equals(Category.top),
        );
      });

      test('returns health', () {
        expect(
          Category.fromString('health'),
          equals(Category.health),
        );
      });

      test('returns science', () {
        expect(
          Category.fromString('science'),
          equals(Category.science),
        );
      });

      test('returns sports', () {
        expect(
          Category.fromString('sports'),
          equals(Category.sports),
        );
      });

      test('returns technology', () {
        expect(
          Category.fromString('technology'),
          equals(Category.technology),
        );
      });
    });
  });
}
