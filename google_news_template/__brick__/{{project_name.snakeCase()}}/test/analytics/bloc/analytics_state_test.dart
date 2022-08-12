import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/analytics/analytics.dart';

void main() {
  group('AnalyticsState', () {
    group('AnalyticsInitial', () {
      test('supports value comparisons', () {
        expect(AnalyticsInitial(), AnalyticsInitial());
      });
    });
  });
}
