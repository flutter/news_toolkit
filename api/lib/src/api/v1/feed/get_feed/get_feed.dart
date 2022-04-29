import 'package:google_news_template_api/src/api/v1/feed/get_feed/models/feed_response.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/data/news_data_source.dart';
import 'package:google_news_template_api/src/di.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching a news feed.
mixin GetFeedMixin on Controller {
  /// Get the news feed.
  Future<Response> getFeed(Request request) async {
    final feed = await request.get<NewsDataSource>().getFeed();
    final response = FeedResponse(
      feed: feed.blocks,
      totalCount: feed.totalBlocks,
    );
    return JsonResponse.ok(body: response.toJson());
  }
}
