// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, lines_longer_than_80_chars

import 'package:news_blocks/news_blocks.dart';
import 'package:test/test.dart';

class CustomBlock extends NewsBlock {
  CustomBlock({super.type = '__custom_block__'});

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

      test('returns TextCaptionBlock', () {
        final block = TextCaptionBlock(
          text: 'Text caption',
          color: TextCaptionColor.light,
        );
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

      test('returns ImageBlock', () {
        final block = ImageBlock(imageUrl: 'imageUrl');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns VideoBlock', () {
        final block = VideoBlock(videoUrl: 'videoUrl');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns VideoIntroductionBlock', () {
        final block = VideoIntroductionBlock(
          category: PostCategory.technology,
          title: 'title',
          videoUrl: 'videoUrl',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns ArticleIntroductionBlock', () {
        final block = ArticleIntroductionBlock(
          category: PostCategory.technology,
          author: 'author',
          publishedAt: DateTime(2022, 3, 9),
          imageUrl: 'imageUrl',
          title: 'title',
        );
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
            ),
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

      test('returns NewsletterBlock', () {
        final block = NewsletterBlock();

        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns BannerAdBlock', () {
        final block = BannerAdBlock(
          size: BannerAdSize.normal,
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns HtmlBlock', () {
        final block = HtmlBlock(content: '<p>hello</p>');
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideBlock', () {
        final block = SlideBlock(
          imageUrl: 'imageUrl',
          caption: 'caption',
          photoCredit: 'photoCredit',
          description: 'description',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideshowBlock', () {
        final slide = SlideBlock(
          imageUrl: 'imageUrl',
          caption: 'caption',
          photoCredit: 'photoCredit',
          description: 'description',
        );
        final block = SlideshowBlock(title: 'title', slides: [slide]);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns SlideshowIntroductionBlock', () {
        final block = SlideshowIntroductionBlock(
          title: 'title',
          coverImageUrl: 'coverImageUrl',
        );
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });

      test('returns TrendingStoryBlock', () {
        final content = PostSmallBlock(
          id: 'id',
          category: PostCategory.health,
          author: 'author',
          publishedAt: DateTime(2022, 3, 11),
          imageUrl: 'imageUrl',
          title: 'title',
        );
        final block = TrendingStoryBlock(content: content);
        expect(NewsBlock.fromJson(block.toJson()), equals(block));
      });
    });
  });
}
