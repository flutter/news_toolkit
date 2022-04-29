import 'package:google_news_template_api/api.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  group('Dependency Injection', () {
    test(
        'values can be injected into a pipeline '
        'and accessed from the request', () async {
      const stringValue = '__stringValue__';
      const intValue = 42;
      const boolValue = false;

      final requests = <Request>[];
      final handler = const Pipeline()
          .inject(stringValue)
          .inject(intValue)
          .inject(boolValue)
          .addHandler((request) {
        requests.add(request);
        return Response.ok('');
      });

      await handler(Request('GET', Uri.parse('http://localhost:8080/')));

      expect(requests.length, equals(1));

      final request = requests.first;

      expect(request.get<String>(), equals(stringValue));
      expect(request.get<int>(), equals(intValue));
      expect(request.get<bool>(), equals(boolValue));
    });

    test(
        'injected values can be overridden '
        'and accessed from the request', () async {
      const stringValue = '__stringValue__';
      const otherStringValue = '__otherStringValue__';

      final requests = <Request>[];
      final handler = const Pipeline()
          .inject(stringValue)
          .inject(otherStringValue)
          .addHandler((request) {
        requests.add(request);
        return Response.ok('');
      });

      await handler(Request('GET', Uri.parse('http://localhost:8080/')));

      expect(requests.length, equals(1));

      final request = requests.first;

      expect(request.get<String>(), equals(otherStringValue));
    });
  });
}
