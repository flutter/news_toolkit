import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/client.dart';

/// {@template news_failure}
/// Base failure class for the news repository failures.
/// {@endtemplate}
abstract class NewsFailure with EquatableMixin implements Exception {
  /// {@macro news_failure}
  const NewsFailure(this.error, this.stackTrace);

  /// The error which was caught.
  final Object error;

  /// The stack trace associated with the [error].
  final StackTrace stackTrace;

  @override
  List<Object?> get props => [error, stackTrace];
}

/// {@template get_feed_failure}
/// Thrown when fetching feed fails.
/// {@endtemplate}
class GetFeedFailure extends NewsFailure {
  /// {@macro get_feed_failure}
  const GetFeedFailure(
    Object error,
    StackTrace stackTrace,
  ) : super(error, stackTrace);
}

/// {@template news_repository}
/// A repository that manages news data.
/// {@endtemplate}
class NewsRepository {
  /// {@macro news_repository}
  const NewsRepository({
    required GoogleNewsTemplateApiClient apiClient,
  }) : _apiClient = apiClient;

  final GoogleNewsTemplateApiClient _apiClient;

  /// Requests news feed metadata.
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
      throw GetFeedFailure(error, stackTrace);
    }
  }
}
