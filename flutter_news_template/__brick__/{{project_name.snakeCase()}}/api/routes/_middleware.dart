import 'package:dart_frog/dart_frog.dart';

import 'package:{{project_name.snakeCase()}}_api/api.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(userProvider())
      .use(newsDataSourceProvider());
}
