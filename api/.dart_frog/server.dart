// ignore_for_file: prefer_single_quotes, implicit_dynamic_list_literal, prefer_const_constructors, lines_longer_than_80_chars, avoid_dynamic_calls, library_prefixes, directives_ordering

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

import '../routes/index.dart' as index;
import '../routes/api/v1/users/me.dart' as api_v1_users_me;
import '../routes/api/v1/subscriptions/index.dart' as api_v1_subscriptions_index;
import '../routes/api/v1/search/relevant.dart' as api_v1_search_relevant;
import '../routes/api/v1/search/popular.dart' as api_v1_search_popular;
import '../routes/api/v1/newsletter/subscription.dart' as api_v1_newsletter_subscription;
import '../routes/api/v1/feed/index.dart' as api_v1_feed_index;
import '../routes/api/v1/categories/index.dart' as api_v1_categories_index;
import '../routes/api/v1/articles/[id]/related.dart' as api_v1_articles_$id_related;
import '../routes/api/v1/articles/[id]/index.dart' as api_v1_articles_$id_index;

import '../routes/_middleware.dart' as middleware;

void main() => hotReload(createServer);

Future<HttpServer> createServer() {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, ip, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/api/v1/articles', (r) => buildApiV1ArticlesHandler()(r))
    ..mount('/api/v1/categories', (r) => buildApiV1CategoriesHandler()(r))
    ..mount('/api/v1/feed', (r) => buildApiV1FeedHandler()(r))
    ..mount('/api/v1/newsletter', (r) => buildApiV1NewsletterHandler()(r))
    ..mount('/api/v1/search', (r) => buildApiV1SearchHandler()(r))
    ..mount('/api/v1/subscriptions', (r) => buildApiV1SubscriptionsHandler()(r))
    ..mount('/api/v1/users', (r) => buildApiV1UsersHandler()(r))
    ..mount('/api/v1', (r) => buildApiV1Handler()(r))
    ..mount('/api', (r) => buildApiHandler()(r))
    ..mount('/', (r) => buildHandler()(r));
  return pipeline.addHandler(router);
}

Handler buildApiV1ArticlesHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/<id>/related', api_v1_articles_$id_related.onRequest)..all('/<id>', api_v1_articles_$id_index.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1CategoriesHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/', api_v1_categories_index.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1FeedHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/', api_v1_feed_index.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1NewsletterHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/subscription', api_v1_newsletter_subscription.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1SearchHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/relevant', api_v1_search_relevant.onRequest)..all('/popular', api_v1_search_popular.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1SubscriptionsHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/', api_v1_subscriptions_index.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1UsersHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/me', api_v1_users_me.onRequest);
  return pipeline.addHandler(router);
}

Handler buildApiV1Handler() {
  const pipeline = Pipeline();
  final router = Router()
    ;
  return pipeline.addHandler(router);
}

Handler buildApiHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ;
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  const pipeline = Pipeline();
  final router = Router()
    ..all('/', index.onRequest);
  return pipeline.addHandler(router);
}
