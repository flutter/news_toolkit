import 'dart:async';
import 'dart:io' as io;

import 'package:google_news_template_api/google_news_template_api.dart';
import 'package:meta/meta.dart' show isTest;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:test/test.dart' as test;

const port = 8080;

@isTest
Future<void> testServer(
  String description,
  FutureOr<void> Function(Uri) body, {
  Handler Function()? handler,
}) async {
  test.test(description, () async {
    late final shelf_io.IOServer server;
    try {
      server = await shelf_io.IOServer.bind(
        io.InternetAddress.loopbackIPv6,
        port,
      );
    } on io.SocketException catch (_) {
      server = await shelf_io.IOServer.bind(
        io.InternetAddress.loopbackIPv4,
        port,
      );
    }

    server.mount(handler?.call() ?? const ApiController().handler);
    await body(server.url);
    await server.close();
  });
}
