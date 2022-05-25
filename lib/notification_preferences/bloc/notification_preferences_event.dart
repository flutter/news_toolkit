part of 'notification_preferences_bloc.dart';

abstract class NotificationPreferencesEvent extends Equatable {
  const NotificationPreferencesEvent();
}

class LoadCategoriesRequested extends NotificationPreferencesEvent {
  @override
  List<Object?> get props => [];
}

class NotificationPreferencesToggled extends NotificationPreferencesEvent {
  const NotificationPreferencesToggled({required this.preference});

  final String preference;

  @override
  List<Object?> get props => [preference];
}
