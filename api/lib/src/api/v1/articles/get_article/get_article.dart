import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching article content.
mixin GetArticleMixin on Controller {
  /// Get the article content for the provided [id].
  Future<Response> getArticle(Request request, String id) async {
    final queryParams = request.url.queryParameters;

    final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
    final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
    final previewRequested = queryParams['preview'] == 'true';

    final isPremium =
        await request.get<NewsDataSource>().isPremiumArticle(id: id);

    if (isPremium == null) return JsonResponse.notFound();

    final isPreview = previewRequested ||
        !(await request.canAccessFullArticle(id: id, isPremium: isPremium));

    final article = await request.get<NewsDataSource>().getArticle(
          id: id,
          limit: limit,
          offset: offset,
          preview: isPreview,
        );

    if (article == null) return JsonResponse.notFound();

    final response = ArticleResponse(
      title: article.title,
      content: article.blocks,
      totalCount: article.totalBlocks,
      url: article.url,
      isPremium: isPremium,
      isPreview: isPreview,
    );

    return JsonResponse.ok(body: response.toJson());
  }
}

extension on Request {
  /// Returns whether the current user may access the full article content
  /// of the article with associated [id].
  Future<bool> canAccessFullArticle({
    required String id,
    required bool isPremium,
  }) async {
    if (!isPremium) return true;
    final currentUserId = userId;
    if (isPremium && currentUserId == null) return false;
    final user = await get<NewsDataSource>().getUser(userId: currentUserId!);
    return user != null && user.subscription != SubscriptionPlan.none;
  }

  /// Returns the current user id.
  String? get userId {
    final authorizationHeader = headers['authorization'];
    if (authorizationHeader == null) return null;
    final segments = authorizationHeader.split(' ');
    if (segments.length != 2) return null;
    if (segments.first.toLowerCase() != 'bearer') return null;
    final userId = segments.last;
    return userId;
  }
}
