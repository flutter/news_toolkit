import 'dart:io';

import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for searching for popular content.
mixin PopularSearchMixin on Controller {
  /// Search for popular news content.
  Future<Response> popularSearch(Request request) async {
    return Response(HttpStatus.notImplemented);
  }
}
