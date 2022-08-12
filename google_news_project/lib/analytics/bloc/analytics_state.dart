part of 'analytics_bloc.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
}

class AnalyticsInitial extends AnalyticsState {
  @override
  List<Object> get props => [];
}
