import 'package:http/http.dart';
import 'package:test/test.dart';

void runTests(
  void Function(String name, Future<void> Function(String host)) testServer,
) {
  testServer('/', (host) async {
    final response = await get(Uri.parse(host));
    expect(response.statusCode, 204);
    expect(response.body, isEmpty);
  });

  testServer('404', (host) async {
    final response = await get(Uri.parse('$host/not_here'));
    expect(response.statusCode, 404);
    expect(response.body, 'Route not found');
  });
}
