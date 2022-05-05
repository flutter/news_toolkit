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
    return _newsData[category] ?? const Feed(blocks: [], totalBlocks: 0);
  }

  @override
  Future<List<Category>> getCategories() async => _newsData.keys.toList();
}

/// The static news feed content.

/// Top news blocks.
final topNewsBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Breaking News'),
  const DividerHorizontalBlock(),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Technology blocks.
final technologyBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Technology'),
  const DividerHorizontalBlock(),
  PostLargeBlock(
    id: '499305f6-5096-4051-afda-824dcfc7df23',
    category: PostCategory.technology,
    author: 'Sean Hollister',
    publishedAt: DateTime(2022, 3, 9),
    imageUrl:
        'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
    title: 'Nvidia and AMD GPUs are returning to shelves '
        'and prices are finally falling',
  ),
  const SpacerBlock(spacing: Spacing.medium),
];

/// Sports blocks.
const sportsBlocks = <NewsBlock>[
  SectionHeaderBlock(title: 'Sports'),
  DividerHorizontalBlock(),
  SpacerBlock(spacing: Spacing.medium),
];

final _newsData = <Category, Feed>{
  Category.top: topNewsBlocks.toFeed(),
  Category.technology: technologyBlocks.toFeed(),
  Category.sports: sportsBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
}
