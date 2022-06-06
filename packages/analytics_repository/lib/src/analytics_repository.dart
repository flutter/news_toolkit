import 'package:analytics_repository/analytics_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// {@template analytics_failure}
/// A base failure for the analytics repository failures.
/// {@endtemplate}
abstract class AnalyticsFailure with EquatableMixin implements Exception {
  /// {@macro analytics_failure}
  const AnalyticsFailure(this.error);

  /// The error which was caught.
  final Object error;

  @override
  List<Object> get props => [error];
}

/// {@template track_event_failure}
/// Thrown when tracking an event fails.
/// {@endtemplate}
class TrackEventFailure extends AnalyticsFailure {
  /// {@macro track_event_failure}
  const TrackEventFailure(super.error);
}

/// {@template analytics_repository}
/// Repository which manages tracking analytics.
/// {@endtemplate}
class AnalyticsRepository {
  /// {@macro analytics_repository}
  const AnalyticsRepository(FirebaseAnalytics analytics)
      : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  /// Tracks the provided [AnalyticsEvent].
  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.name,
        parameters: event.properties,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }
}
