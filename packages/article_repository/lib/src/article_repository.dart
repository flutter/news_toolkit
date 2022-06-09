import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/client.dart';
import 'package:storage/storage.dart';

part 'article_storage.dart';

/// {@template article_failure}
/// A base failure for the article repository failures.
/// {@endtemplate}
abstract class ArticleFailure with EquatableMixin implements Exception {
  /// {@macro article_failure}
  const ArticleFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template get_article_failure}
/// Thrown when fetching an article fails.
/// {@endtemplate}
class GetArticleFailure extends ArticleFailure {
  /// {@macro get_article_failure}
  const GetArticleFailure(super.error);
}

/// {@template get_related_articles_failure}
/// Thrown when fetching related articles fails.
/// {@endtemplate}
class GetRelatedArticlesFailure extends ArticleFailure {
  /// {@macro get_related_articles_failure}
  const GetRelatedArticlesFailure(super.error);
}

/// {@template increment_article_views_failure}
/// Thrown when incrementing article views fails.
/// {@endtemplate}
class IncrementArticleViewsFailure extends ArticleFailure {
  /// {@macro increment_article_views_failure}
  const IncrementArticleViewsFailure(super.error);
}

/// {@template reset_article_views_failure}
/// Thrown when resetting article views fails.
/// {@endtemplate}
class ResetArticleViewsFailure extends ArticleFailure {
  /// {@macro reset_article_views_failure}
  const ResetArticleViewsFailure(super.error);
}

/// {@template fetch_article_views_failure}
/// Thrown when fetching article views fails.
/// {@endtemplate}
class FetchArticleViewsFailure extends ArticleFailure {
  /// {@macro fetch_article_views_failure}
  const FetchArticleViewsFailure(super.error);
}

/// {@template article_views}
/// Represents the number of article views and the date
/// when the number of article views was last reset.
/// {@endtemplate}
class ArticleViews {
  /// {@macro article_views}
  ArticleViews(this.views, this.resetAt);

  /// The number of article views.
  final int views;

  /// The date when the number of article views was last reset.
  final DateTime? resetAt;
}

/// {@template article_repository}
/// A repository that manages article data.
/// {@endtemplate}
class ArticleRepository {
  /// {@macro article_repository}
  const ArticleRepository({
    required GoogleNewsTemplateApiClient apiClient,
    required ArticleStorage storage,
  })  : _apiClient = apiClient,
        _storage = storage;

  final GoogleNewsTemplateApiClient _apiClient;
  final ArticleStorage _storage;

  /// Requests article content metadata.
  ///
  /// Supported parameters:
  /// * [id] - article id for which content is requested.
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<ArticleResponse> getArticle({
    required String id,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getArticle(
        id: id,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetArticleFailure(error), stackTrace);
    }
  }

  /// Requests related articles.
  ///
  /// Supported parameters:
  /// * [id] - article id for which related content is requested.
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<RelatedArticlesResponse> getRelatedArticles({
    required String id,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getRelatedArticles(
        id: id,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetRelatedArticlesFailure(error), stackTrace);
    }
  }

  /// Increments the number of article views by 1.
  Future<void> incrementArticleViews() async {
    try {
      final currentArticleViews = await _storage.fetchArticleViews();
      await _storage.setArticleViews(currentArticleViews + 1);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  /// Resets the number of article views.
  Future<void> resetArticleViews() async {
    try {
      await Future.wait([
        _storage.setArticleViews(0),
        _storage.setArticleViewsResetDate(clock.now()),
      ]);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ResetArticleViewsFailure(error),
        stackTrace,
      );
    }
  }

  /// Fetches the number of article views.
  Future<ArticleViews> fetchArticleViews() async {
    try {
      late int views;
      late DateTime? resetAt;
      await Future.wait([
        (() async => views = await _storage.fetchArticleViews())(),
        (() async => resetAt = await _storage.fetchArticleViewsResetDate())(),
      ]);
      return ArticleViews(views, resetAt);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        FetchArticleViewsFailure(error),
        stackTrace,
      );
    }
  }
}
