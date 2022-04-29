import 'package:google_news_template_api/src/api/v1/v1.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template api_controller}
/// The root controller which is responsible for
/// exposing the [Handler] for all API routes.
/// {@endtemplate}
class ApiController extends Controller {
  /// {@macro api_controller}
  const ApiController();

  @override
  Handler get handler {
    return Router()
      ..get('/', (Request _) => JsonResponse.noContent())
      ..register('/api/v1', const ApiV1Controller());
  }
}
