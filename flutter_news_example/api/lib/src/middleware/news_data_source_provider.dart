import 'package:dart_frog/dart_frog.dart';
import 'package:flutter_news_example_api/api.dart';

final _newsDataSource = InMemoryNewsDataSource();

/// Provider a [NewsDataSource] to the current [RequestContext].
Middleware newsDataSourceProvider() {
  return (handler) {
    return handler.use(provider<NewsDataSource>((_) => _newsDataSource));
  };
}
