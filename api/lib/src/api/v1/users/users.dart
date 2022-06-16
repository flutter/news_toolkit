import 'package:google_news_template_api/src/api/v1/users/get_current_user/get_current_user.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template users}
/// Controller for `/api/v1/users` routes.
/// {@endtemplate}
class UsersController extends Controller with GetCurrentUserMixin {
  /// {@macro users}
  const UsersController();

  @override
  Handler get handler {
    return Router()..get('/me', getCurrentUser);
  }
}
