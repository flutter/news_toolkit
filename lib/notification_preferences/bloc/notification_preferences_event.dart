part of 'notification_preferences_bloc.dart';

abstract class NotificationPreferencesEvent extends Equatable {
  const NotificationPreferencesEvent();
}

class NotificationPreferencesToggled extends NotificationPreferencesEvent {
  const NotificationPreferencesToggled({required this.category});

  final Category category;

  @override
  List<Object?> get props => [category];
}
