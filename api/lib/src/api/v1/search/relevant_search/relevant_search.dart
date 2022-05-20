import 'dart:io';

import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for searching for relevant content.
mixin RelevantSearchMixin on Controller {
  /// Search for relevant news content based on the `q` query parameter.
  Future<Response> relevantSearch(Request request) async {
    return Response(HttpStatus.notImplemented);
  }
}
