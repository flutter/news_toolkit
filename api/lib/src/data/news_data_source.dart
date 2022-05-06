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

/// Top news blocks.
final topNewsBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Breaking News'),
  const DividerHorizontalBlock(),
  const SpacerBlock(spacing: Spacing.medium),
  _technologyPost
];

/// Technology blocks.
final technologyBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Technology'),
  const DividerHorizontalBlock(),
  _technologyPost,
  const SpacerBlock(spacing: Spacing.medium),
  _sportsPost,
  const SpacerBlock(spacing: Spacing.small),
  _healthPost,
  const SpacerBlock(spacing: Spacing.extraSmall),
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

final _newsData = <Category, Feed>{
  Category.top: topNewsBlocks.toFeed(),
  Category.technology: technologyBlocks.toFeed(),
  Category.sports: sportsBlocks.toFeed(),
  Category.health: healthBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
}
