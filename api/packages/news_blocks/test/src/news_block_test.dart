// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, lines_longer_than_80_chars

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

    group('fromJson', () {
      test('returns UnknownBlock when type is missing', () {
        expect(NewsBlock.fromJson(<String, dynamic>{}), isA<UnknownBlock>());
      });

      test('returns UnknownBlock when type is unrecognized', () {
        expect(
          NewsBlock.fromJson(<String, dynamic>{'type': 'unrecognized'}),
          isA<UnknownBlock>(),
        );
      });

      test('returns SectionHeaderBlock', () {
        final block = SectionHeaderBlock(title: 'Example');
        expect(
          NewsBlock.fromJson(block.toJson()),
          isA<SectionHeaderBlock>(),
        );
      });
    });
  });
}
