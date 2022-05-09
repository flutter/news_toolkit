import 'dart:math' as math;

import 'package:google_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
  /// {@macro news_data_source}
  const NewsDataSource();

  /// Returns a news [Feed] for the provided [category].
  /// By default [Category.top] is used.
  ///
  /// In addition, the feed can be paginated by supplying
  /// [limit] and [offset].
  ///
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<Feed> getFeed({
    Category category = Category.top,
    int limit = 20,
    int offset = 0,
  });

  /// Returns a list of all available news categories.
  Future<List<Category>> getCategories();
}

/// {@template in_memory_news_data_source}
/// An implementation of [NewsDataSource] which
/// is powered by in-memory news content.
/// {@endtemplate}
class InMemoryNewsDataSource implements NewsDataSource {
  /// {@macro in_memory_news_data_store}
  const InMemoryNewsDataSource();

  @override
  Future<Feed> getFeed({
    Category category = Category.top,
    int limit = 20,
    int offset = 0,
  }) async {
    final feed = _newsData[category] ?? const Feed(blocks: [], totalBlocks: 0);
    final totalBlocks = feed.totalBlocks;
    final normalizedOffset = math.min(offset, totalBlocks);
    final blocks = feed.blocks.sublist(normalizedOffset).take(limit).toList();
    return Feed(blocks: blocks, totalBlocks: totalBlocks);
  }

  @override
  Future<List<Category>> getCategories() async => _newsData.keys.toList();
}

/// The static news feed content.
final _technologyPost = PostLargeBlock(
  id: '499305f6-5096-4051-afda-824dcfc7df23',
  category: PostCategory.technology,
  author: 'Sean Hollister',
  publishedAt: DateTime(2022, 3, 9),
  imageUrl:
      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
  title: 'Nvidia and AMD GPUs are returning to shelves '
      'and prices are finally falling',
);

final _sportsPost = PostMediumBlock(
  id: '82c49bf1-946d-4920-a801-302291f367b5',
  category: PostCategory.sports,
  author: 'Tom Dierberger',
  publishedAt: DateTime(2022, 3, 10),
  imageUrl:
      'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
  title: 'Patrick Beverley throws shade at Warriors '
      'for Ja Morant struggles - NBC Sports',
  description:
      'Patrick Beverley is no longer participating in the NBA playoffs, '
      'but he sure has a lot to say. In Game 2 between the Warriors and '
      'Memphis Grizzlies on Tuesday night, Ja Morant torched the Dubs '
      'for 47 points...',
);

final _healthPost = PostSmallBlock(
  id: 'b1fc2ffc-eb02-42ce-af65-79702172a987',
  category: PostCategory.health,
  author: 'Northwestern University',
  publishedAt: DateTime(2022, 3, 11),
  imageUrl: 'https://scitechdaily.com/images/Ear-Hearing-Concept.jpg',
  title: 'Restoring Hearing: New Tool To Create Ear Hair Cells '
      'Lost Due to Aging or Noise - SciTechDaily',
  description:
      '‘We have overcome a major hurdle’ to restore hearing, investigators say.'
      ' Gene discovery allows the production of inner or outer ear hair cells, '
      'death of outer hair cells due to aging or noise cause most '
      'hearing loss...',
);

final _scienceGridGroupPost = PostGridGroupBlock(
  category: PostCategory.science,
  tiles: [
    PostGridTileBlock(
      id: '384a15ff-a50e-46d5-96a7-8864facdcc48',
      category: PostCategory.science,
      author: 'Loren Grush',
      publishedAt: DateTime(2022, 5, 6),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/eqkJgsUMn-iJOrN98c4gduFGDT8=/0x74:1050x624/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/23441881/Screen_Shot_2022_05_06_at_1.13.12_AM.png',
      title:
          'SpaceX successfully returns four astronauts from the International '
          'Space Station - The Verge',
    ),
    PostGridTileBlock(
      id: '13e448bb-cd26-4ae0-b138-4a67067f7a93',
      category: PostCategory.science,
      author: 'Daniel Strain',
      publishedAt: DateTime(2022, 5, 6),
      imageUrl:
          'https://scx2.b-cdn.net/gfx/news/2022/a-surging-glow-in-a-di.jpg',
      title:
          'A surging glow in a distant galaxy could change the way we look at '
          'black holes',
    ),
    PostGridTileBlock(
      id: '842e3193-86d2-4069-a7e6-f769faa6f970',
      category: PostCategory.science,
      author: 'SciTechDaily',
      publishedAt: DateTime(2022, 5, 5),
      imageUrl:
          'https://scitechdaily.com/images/Qubit-Platform-Single-Electron-on-Solid-Neon.jpg',
      title: 'The Quest for an Ideal Quantum Bit: New Qubit Breakthrough Could '
          'Revolutionize Quantum Computing',
    ),
    PostGridTileBlock(
      id: '1f79da6f-64cb-430a-b7b2-2318d23b719f',
      category: PostCategory.science,
      author: 'SciTechDaily',
      publishedAt: DateTime(2022, 5, 4),
      imageUrl: 'https://scitechdaily.com/images/Black-Hole-Sonification.gif',
      title: 'Hear What a Black Hole Sounds Like – New NASA Black Hole '
          'Sonifications With a Remix',
    ),
  ],
);

/// Top news blocks.
final topNewsBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Breaking News'),
  const DividerHorizontalBlock(),
  const SpacerBlock(spacing: Spacing.medium),
  _technologyPost,
  const SpacerBlock(spacing: Spacing.medium),
  _sportsPost,
  const SpacerBlock(spacing: Spacing.small),
  _healthPost,
  const SpacerBlock(spacing: Spacing.extraSmall),
];

/// Technology blocks.
final technologyBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Technology'),
  const DividerHorizontalBlock(),
  _technologyPost,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Sports blocks.
final sportsBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Sports'),
  const DividerHorizontalBlock(),
  _sportsPost,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Health blocks.
final healthBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Health'),
  const DividerHorizontalBlock(),
  _healthPost,
  const SpacerBlock(spacing: Spacing.medium),
];

/// Science blocks.
final scienceBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Science'),
  const DividerHorizontalBlock(),
  _scienceGridGroupPost,
  const SpacerBlock(spacing: Spacing.medium),
];

final _newsData = <Category, Feed>{
  Category.top: topNewsBlocks.toFeed(),
  Category.technology: technologyBlocks.toFeed(),
  Category.sports: sportsBlocks.toFeed(),
  Category.health: healthBlocks.toFeed(),
  Category.science: scienceBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
}
