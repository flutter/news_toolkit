import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

void main() {
  group(Category, () {
    test('can be (de)serialized', () {
      const category = Category(id: 'sports', name: 'Sports');
      expect(
        Category.fromJson(const {'id': 'sports', 'name': 'Sports'}),
        equals(category),
      );
    });

    test('can be serialized', () {
      const category = Category(id: 'sports', name: 'Sports');
      expect(
        category.toJson(),
        equals(const {'id': 'sports', 'name': 'Sports'}),
      );
    });
  });
}
