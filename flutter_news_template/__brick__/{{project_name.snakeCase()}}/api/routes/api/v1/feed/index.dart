import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final queryParams = context.request.url.queryParameters;
  final categoryQueryParam = queryParams['category'];

  final limit = int.tryParse(queryParams['limit'] ?? '') ?? 20;
  final offset = int.tryParse(queryParams['offset'] ?? '') ?? 0;
  final feed = await context.read<NewsDataSource>().getFeed(
        categoryId: categoryQueryParam ?? '',
        limit: limit,
        offset: offset,
      );
  final response = FeedResponse(
    feed: feed.blocks,
    totalCount: feed.totalBlocks,
  );
  return Response.json(body: response);
}
