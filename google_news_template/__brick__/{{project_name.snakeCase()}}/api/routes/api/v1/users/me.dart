import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:{{project_name.snakeCase()}}_api/api.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final _user = context.read<RequestUser>();
  if (_user.isAnonymous) return Response(statusCode: HttpStatus.badRequest);

  final user = await context.read<NewsDataSource>().getUser(userId: _user.id);
  if (user == null) return Response(statusCode: HttpStatus.notFound);

  final response = CurrentUserResponse(user: user);
  return Response.json(body: response);
}
