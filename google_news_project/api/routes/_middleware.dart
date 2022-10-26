import 'package:dart_frog/dart_frog.dart';

import 'package:google_news_template_api/api.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(userProvider())
      .use(newsDataSourceProvider());
}
