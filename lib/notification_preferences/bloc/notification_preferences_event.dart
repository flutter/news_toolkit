part of 'notification_preferences_bloc.dart';

abstract class NotificationPreferencesEvent extends Equatable {
  const NotificationPreferencesEvent();
}

class CategoriesPreferenceToggled extends NotificationPreferencesEvent {
  const CategoriesPreferenceToggled({required this.category});

  final Category category;

  @override
  List<Object?> get props => [category];
}

class InitialCategoriesPreferencesRequested
    extends NotificationPreferencesEvent {
  @override
  List<Object?> get props => [];
}
