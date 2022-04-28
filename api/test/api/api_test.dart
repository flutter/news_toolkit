import 'package:http/http.dart';
import 'package:test/test.dart';

import '../test_server.dart';

void main() {
  group('ApiController', () {
    group('GET /', () {
      testServer('returns 204', (host) async {
        final response = await get(host);
        expect(response.statusCode, equals(204));
        expect(response.body, isEmpty);
      });
    });
  });
}
