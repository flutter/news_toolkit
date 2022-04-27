import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final router = Router()..get('/', (Request _) => Response(204));
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  // ignore: avoid_print
  print('Serving at http://${server.address.host}:${server.port}');
}
