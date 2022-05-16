import 'dart:io';

import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support
/// for fetching related article content.
mixin GetRelatedArticlesMixin on Controller {
  /// Get the related article content for the provided article [id].
  Future<Response> getRelatedArticles(Request request, String id) async {
    return Response(HttpStatus.notImplemented);
  }
}
