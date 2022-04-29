import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:google_news_template_api/src/json_response.dart';
import 'package:shelf/shelf.dart';

/// Mixin on [Controller] which adds support for fetching news categories.
mixin GetCategoriesMixin on Controller {
  /// Get the available news categories.
  Future<Response> getCategories(Request request) async {
    final categories = await request.get<NewsDataSource>().getCategories();
    final response = CategoriesResponse(
      categories: categories,
    );
    return JsonResponse.ok(body: response.toJson());
  }
}
