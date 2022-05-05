import 'package:google_news_template_api/api.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
  /// {@macro news_data_source}
  const NewsDataSource();

  /// Returns a news [Feed].
  Future<Feed> getFeed();

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
  Future<Feed> getFeed() async => _topNewsBlocks.toFeed();

  @override
  Future<List<Category>> getCategories() async => _newsData.keys.toList();
}

/// The static news feed content.
final _technologyPostLarge = PostLargeBlock(
  id: '499305f6-5096-4051-afda-824dcfc7df23',
  category: PostCategory.technology,
  author: 'Sean Hollister',
  publishedAt: DateTime(2022, 3, 9),
  imageUrl:
      'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
  title: 'Nvidia and AMD GPUs are returning to shelves '
      'and prices are finally falling',
);

final _topNewsBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Breaking News'),
  const DividerHorizontalBlock(),
  _technologyPostLarge,
];

final _technologyBlocks = <NewsBlock>[
  const SectionHeaderBlock(title: 'Technology'),
  const DividerHorizontalBlock(),
  _technologyPostLarge,
];

const _sportsBlocks = <NewsBlock>[
  SectionHeaderBlock(title: 'Sports'),
  DividerHorizontalBlock(),
];

final _newsData = <Category, Feed>{
  Category.top: _topNewsBlocks.toFeed(),
  Category.technology: _technologyBlocks.toFeed(),
  Category.sports: _sportsBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
}
