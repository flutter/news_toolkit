import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// {@template analytics_repository}
/// Repository which manages tracking analytics.
/// {@endtemplate}
class AnalyticsRepository {
  /// {@macro analytics_repository}
  const AnalyticsRepository(FirebaseAnalytics analytics)
      : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  /// Tracks the provided [AnalyticsEvent].
  void track(AnalyticsEvent event) {
    _analytics.logEvent(
      name: event.name,
      parameters: event.properties,
    );
  }
}
