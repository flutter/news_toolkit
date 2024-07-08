import 'package:equatable/equatable.dart';

/// {@template analytics_event}
/// An analytic event which can be tracked.
/// Consists of the unique event name and an optional
/// map of properties.
/// {@endtemplate}
class AnalyticsEvent extends Equatable {
  /// {@macro analytics_event}
  const AnalyticsEvent(this.name, {this.properties});

  /// Unique event name.
  final String name;

  /// Optional map of event properties.
  final Map<String, Object>? properties;

  @override
  List<Object?> get props => [name, properties];
}

/// Mixin for tracking analytics events.
mixin AnalyticsEventMixin on Equatable {
  /// Analytics event which will be tracked.
  AnalyticsEvent get event;

  @override
  List<Object> get props => [event];
}
