// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class CustomBlock extends NewsBlock {
  CustomBlock() : super(type: '__custom_block__');

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'type': type};
}

void main() {
  group('NewsBlock', () {
    test('can be extended', () {
      expect(CustomBlock.new, returnsNormally);
    });
  });
}
