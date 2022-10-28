import 'package:analytics_repository/analytics_repository.dart' as analytics;
import 'package:{{project_name.snakeCase()}}/analytics/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockUser extends Mock implements User {}

class MockAnalyticsEvent extends Mock implements analytics.AnalyticsEvent {}

void main() {
  group('AnalyticsEvent', () {
    group('TrackAnalyticsEvent', () {
      test('supports value comparisons', () {
        final event = MockAnalyticsEvent();
        expect(TrackAnalyticsEvent(event), TrackAnalyticsEvent(event));
      });
    });
  });
}
