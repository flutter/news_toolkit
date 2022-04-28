@Tags(['presubmit-only'])
import 'package:test/test.dart';

import 'test_definitions.dart';

void main() {
  void testServer(String name, Future<void> Function(String host) func) {
    test(
      name,
      () => func('http://localhost:8080'),
      timeout: _defaultTimeout,
    );
  }

  runTests(testServer);
}

const _defaultTimeout = Timeout(Duration(seconds: 3));
