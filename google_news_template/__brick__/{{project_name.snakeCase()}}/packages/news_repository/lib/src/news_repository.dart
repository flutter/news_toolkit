import 'package:equatable/equatable.dart';
import 'package:{{project_name.snakeCase()}}_api/client.dart';

/// {@template news_failure}
/// Base failure class for the news repository failures.
/// {@endtemplate}
abstract class NewsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const NewsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object?> get props => [error];
}

/// {@template get_feed_failure}
/// Thrown when fetching feed fails.
/// {@endtemplate}
class GetFeedFailure extends NewsFailure {
  /// {@macro get_feed_failure}
  const GetFeedFailure(super.error);
}

/// {@template get_categories_failure}
/// Thrown when fetching categories fails.
/// {@endtemplate}
class GetCategoriesFailure extends NewsFailure {
  /// {@macro get_categories_failure}
  const GetCategoriesFailure(super.error);
}

/// {@template popular_search_failure}
/// Thrown when fetching popular searches fails.
/// {@endtemplate}
class PopularSearchFailure extends NewsFailure {
  /// {@macro popular_search_failure}
  const PopularSearchFailure(super.error);
}

/// {@template relevant_search_failure}
/// Thrown when fetching relevant searches fails.
/// {@endtemplate}
class RelevantSearchFailure extends NewsFailure {
  /// {@macro relevant_search_failure}
  const RelevantSearchFailure(super.error);
}

/// {@template news_repository}
/// A repository that manages news data.
/// {@endtemplate}
class NewsRepository {
  /// {@macro news_repository}
  const NewsRepository({
    required {{project_name.pascalCase()}}ApiClient apiClient,
  }) : _apiClient = apiClient;

  final {{project_name.pascalCase()}}ApiClient _apiClient;

  /// Requests news feed metadata.
  ///
  /// Supported parameters:
  /// * [category] - the desired news [Category].
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<FeedResponse> getFeed({
    Category? category,
    int? limit,
    int? offset,
  }) async {
    try {
      return await _apiClient.getFeed(
        category: category,
        limit: limit,
        offset: offset,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFeedFailure(error), stackTrace);
    }
  }

  /// Requests the available news categories.
  Future<CategoriesResponse> getCategories() async {
    try {
      return await _apiClient.getCategories();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetCategoriesFailure(error), stackTrace);
    }
  }

  /// Subscribes the provided [email] to the newsletter.
  Future<void> subscribeToNewsletter({required String email}) async {
    try {
      await _apiClient.subscribeToNewsletter(email: email);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(GetFeedFailure(error), stackTrace);
    }
  }

  /// Requests the popular searches.
  Future<PopularSearchResponse> popularSearch() async {
    try {
      return await _apiClient.popularSearch();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(PopularSearchFailure(error), stackTrace);
    }
  }

  /// Requests the searches relevant to [term].
  Future<RelevantSearchResponse> relevantSearch({required String term}) async {
    try {
      return await _apiClient.relevantSearch(term: term);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(RelevantSearchFailure(error), stackTrace);
    }
  }
}
