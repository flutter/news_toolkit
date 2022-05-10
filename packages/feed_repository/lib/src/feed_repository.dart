import 'package:equatable/equatable.dart';
import 'package:google_news_template_api/client.dart';

/// {@template feed_failure}
/// Base failure class for the lottery repository failures.
/// {@endtemplate}
abstract class FeedFailure with EquatableMixin implements Exception {
  /// {@macro feed_failure}
  const FeedFailure(this.error, this.stackTrace);

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
class GetFeedFailure extends FeedFailure {
  /// {@macro get_feed_failure}
  const GetFeedFailure(
    Object error,
    StackTrace stackTrace,
  ) : super(error, stackTrace);
}

/// {@template feed_repository}
/// A repository that manages content feed data.
/// {@endtemplate}
class FeedRepository {
  /// {@macro feed_repository}
  const FeedRepository({
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
