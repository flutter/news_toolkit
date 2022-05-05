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
const _topNewsBlocks = <NewsBlock>[
  SectionHeaderBlock(title: 'Breaking News'),
  DividerHorizontalBlock(),
  SpacerBlock(spacing: Spacing.medium),
];

const _technologyBlocks = <NewsBlock>[
  SectionHeaderBlock(title: 'Technology'),
  DividerHorizontalBlock(),
  SpacerBlock(spacing: Spacing.medium),
];

const _sportsBlocks = <NewsBlock>[
  SectionHeaderBlock(title: 'Sports'),
  DividerHorizontalBlock(),
  SpacerBlock(spacing: Spacing.medium),
];

final _newsData = <Category, Feed>{
  Category.top: _topNewsBlocks.toFeed(),
  Category.technology: _technologyBlocks.toFeed(),
  Category.sports: _sportsBlocks.toFeed(),
};

extension on List<NewsBlock> {
  Feed toFeed() => Feed(blocks: this, totalBlocks: length);
}
