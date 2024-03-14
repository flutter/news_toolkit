import 'package:{{project_name.snakeCase()}}/main/build_number.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('buildNumber', () {
    test('is not null', () {
      expect(buildNumber(), isNotNull);
    });

    test('returns 0 when packageVersion is empty', () {
      expect(buildNumber(''), 0);
    });

    test('returns 0 when packageVersion is missing a build number', () {
      expect(buildNumber('1.0.0'), 0);
    });

    test('returns 0 when packageVersion has a malformed build number', () {
      expect(buildNumber('1.0.0+'), 0);
    });

    test('returns 42 when build number is 42', () {
      expect(buildNumber('1.0.0+42'), 42);
    });
  });
}
