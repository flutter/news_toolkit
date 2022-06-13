import 'dart:io';

import 'package:google_news_template_api/api.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

Future<void> main() async {
  const controller = ApiController();
  final handler = const Pipeline()
      .inject<NewsDataSource>(InMemoryNewsDataSource())
      .addMiddleware(logRequests())
      .addHandler(controller.handler);
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  // ignore: avoid_print
  print('Serving at http://${server.address.host}:${server.port}');
}
