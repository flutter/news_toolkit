part of 'article_repository.dart';

/// Storage keys for the [ArticleStorage].
abstract class ArticleStorageKeys {
  /// The number of article views.
  static const articleViews = '__article_views_storage_key__';

  /// The date when the number of article views was last reset.
  static const articleViewsResetAt = '__article_views_reset_at_storage_key__';

  /// Number of overall articles views.
  static const overallArticlesViews = '__overall_articles_views_key__';
}

/// {@template article_storage}
/// Storage for the [ArticleRepository].
/// {@endtemplate}
class ArticleStorage {
  /// {@macro article_storage}
  const ArticleStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  /// Sets the number of article views in Storage.
  Future<void> setArticleViews(int views) => _storage.write(
        key: ArticleStorageKeys.articleViews,
        value: views.toString(),
      );

  /// Fetches the number of article views from Storage.
  Future<int> fetchArticleViews() async {
    final articleViews =
        await _storage.read(key: ArticleStorageKeys.articleViews);
    return articleViews != null ? int.parse(articleViews) : 0;
  }

  /// Sets the reset date of the number of article views in Storage.
  Future<void> setArticleViewsResetDate(DateTime date) => _storage.write(
        key: ArticleStorageKeys.articleViewsResetAt,
        value: date.toIso8601String(),
      );

  /// Fetches the reset date of the number of article views from Storage.
  Future<DateTime?> fetchArticleViewsResetDate() async {
    final resetDate =
        await _storage.read(key: ArticleStorageKeys.articleViewsResetAt);
    return resetDate != null ? DateTime.parse(resetDate) : null;
  }

  /// Sets the number of overall articles views.
  Future<void> setOverallArticlesViews(int count) => _storage.write(
        key: ArticleStorageKeys.overallArticlesViews,
        value: count.toString(),
      );

  /// Fetches the number of overall articles views value from Storage.
  Future<int> fetchOverallArticlesViews() async {
    final count =
        await _storage.read(key: ArticleStorageKeys.overallArticlesViews);
    return int.parse(count ?? '0');
  }
}
