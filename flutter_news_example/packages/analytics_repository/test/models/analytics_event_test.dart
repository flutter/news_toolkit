// ignore_for_file: prefer_const_constructors
import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

class TestEvent extends Equatable with AnalyticsEventMixin {
  const TestEvent({required this.id});

  final String id;

  @override
  AnalyticsEvent get event {
    return AnalyticsEvent(
      'TestEvent',
      properties: <String, String>{'test-key': id},
    );
  }
}

void main() {
  group('AnalyticsEventMixin', () {
    const id = 'mock-id';
    test('uses value equality', () {
      expect(TestEvent(id: id), equals(TestEvent(id: id)));
    });
  });
}
