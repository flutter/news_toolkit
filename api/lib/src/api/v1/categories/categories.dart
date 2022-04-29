import 'package:google_news_template_api/src/api/v1/categories/get_categories/get_categories.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template categories_controller}
/// Controller for `/api/v1/categories` routes.
/// {@endtemplate}
class CategoriesController extends Controller with GetCategoriesMixin {
  /// {@macro categories_controller}
  const CategoriesController();

  @override
  Handler get handler {
    return Router()..get('/', getCategories);
  }
}
