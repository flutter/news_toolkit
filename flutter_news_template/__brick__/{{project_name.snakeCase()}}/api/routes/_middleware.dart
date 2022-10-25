import 'package:dart_frog/dart_frog.dart';

import 'package:{{project_name.snakeCase()}}_api/api.dart';

final inMemoryNewsDataSource = InMemoryNewsDataSource();

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(userProvider())
      .use(provider<NewsDataSource>((_) => inMemoryNewsDataSource));
}
