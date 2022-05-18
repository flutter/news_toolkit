import 'package:news_blocks/news_blocks.dart';

/// {@template news_item}
/// An class that contains metadata representing a news item.
/// News items contain the post used within a news feed as well as
/// the article content.
/// {@endtemplate}
class NewsItem {
  /// {@macro post}
  const NewsItem({
    required this.content,
    required this.post,
    this.relatedArticles = const [],
  });

  /// The associated contents.
  final List<NewsBlock> content;

  /// The associated [PostBlock] for the feed.
  final PostBlock post;

  /// The related articles.
  final List<NewsBlock> relatedArticles;
}
