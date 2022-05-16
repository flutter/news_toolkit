import 'package:google_news_template_api/src/api/v1/articles/get_article/get_article.dart';
import 'package:google_news_template_api/src/api/v1/articles/get_related_articles/get_related_articles.dart';
import 'package:google_news_template_api/src/controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// {@template articles}
/// Controller for `/api/v1/articles` routes.
/// {@endtemplate}
class ArticlesController extends Controller
    with GetArticleMixin, GetRelatedArticlesMixin {
  /// {@macro articles}
  const ArticlesController();

  @override
  Handler get handler {
    return Router()
      ..get('/<id>', getArticle)
      ..get('/<id>/related', getRelatedArticles);
  }
}
