import 'package:google_news_template_api/api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for getting the current user.
mixin GetCurrentUserMixin on Controller {
  /// Get the current user.
  Future<Response> getCurrentUser(Request request) async {
    final userId = request.userId;
    if (userId == null) return Response.badRequest();

    final user = await request.get<NewsDataSource>().getUser(userId: userId);
    if (user == null) return JsonResponse.notFound();

    final response = CurrentUserResponse(user: user);
    return JsonResponse.ok(body: response.toJson());
  }
}

extension on Request {
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
