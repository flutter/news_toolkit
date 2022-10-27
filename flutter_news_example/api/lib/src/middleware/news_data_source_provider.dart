import 'package:dart_frog/dart_frog.dart';
import 'package:google_news_template_api/api.dart';

final _newsDataSource = InMemoryNewsDataSource();

/// Provider a [NewsDataSource] to the current [RequestContext].
Middleware newsDataSourceProvider() {
  return (handler) {
    return handler.use(provider<NewsDataSource>((_) => _newsDataSource));
  };
}
