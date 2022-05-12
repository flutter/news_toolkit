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
        expect(NewsBlock.fromJson(<String, dynamic>{}), equals(UnknownBlock()));
      });

      test('returns UnknownBlock when type is unrecognized', () {
        expect(
          NewsBlock.fromJson(<String, dynamic>{'type': 'unrecognized'}),
          equals(UnknownBlock()),
        );
      });

      test('returns SectionHeaderBlock', () {
        final block = SectionHeaderBlock(title: 'Example');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns DividerHorizontalBlock', () {
        final block = DividerHorizontalBlock();
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SpacerBlock', () {
        final block = SpacerBlock(spacing: Spacing.medium);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextHeadlineBlock', () {
        final block = TextHeadlineBlock(text: 'Text Headline');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextLeadParagraphBlock', () {
        final block = TextLeadParagraphBlock(text: 'Text Lead Paragraph');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TextParagraphBlock', () {
        final block = TextParagraphBlock(text: 'Text Paragraph');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostLargeBlock', () {
        final block = PostLargeBlock(
          id: 'id',
          category: PostCategory.technology,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostMediumBlock', () {
        final block = PostMediumBlock(
          id: 'id',
          category: PostCategory.sports,
          author: 'author',
          publishedAt: DateTime(2022, 3, 10),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostSmallBlock', () {
        final block = PostSmallBlock(
          id: 'id',
          category: PostCategory.health,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostGridGroupBlock', () {
        final block = PostGridGroupBlock(
          category: PostCategory.science,
          tiles: [
            PostGridTileBlock(
              id: 'id',
              category: PostCategory.science,
              author: 'author',
              publishedAt: DateTime(2022, 3, 12),
              imageUrl: 'imageUrl',
              title: 'title',
            )
          ],
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns PostGridTileBlock', () {
        final block = PostGridTileBlock(
          id: 'id',
          category: PostCategory.science,
          author: 'author',
          publishedAt: DateTime(2022, 3, 12),
          imageUrl: 'imageUrl',
          title: 'title',
        );

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });
    });
  });
}
