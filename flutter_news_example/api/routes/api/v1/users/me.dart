import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_template_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final reqUser = context.read<RequestUser>();
  if (reqUser.isAnonymous) return Response(statusCode: HttpStatus.badRequest);

  final user = await context.read<NewsDataSource>().getUser(userId: reqUser.id);
  if (user == null) return Response(statusCode: HttpStatus.notFound);

  final response = CurrentUserResponse(user: user);
  return Response.json(body: response);
}
