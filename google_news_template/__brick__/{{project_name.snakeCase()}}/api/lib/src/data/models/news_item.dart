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
    required this.contentPreview,
    required this.post,
    required this.url,
    this.relatedArticles = const [],
  });

  /// The associated content.
  final List<NewsBlock> content;

  /// The associated preview of the content.
  final List<NewsBlock> contentPreview;

  /// The associated [PostBlock] for the feed.
  final PostBlock post;

  /// The associated article url.
  final Uri url;

  /// The related articles.
  final List<NewsBlock> relatedArticles;
}
