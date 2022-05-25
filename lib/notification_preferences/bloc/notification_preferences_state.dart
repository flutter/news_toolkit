part of 'notification_preferences_bloc.dart';

enum NotificationPreferencesStatus {
  initial,
  loading,
  success,
  failure,
}

class NotificationPreferencesState extends Equatable {
  const NotificationPreferencesState({
    required this.togglesState,
    required this.status,
  });

  NotificationPreferencesState.initial()
      : this(
          togglesState: {},
          status: NotificationPreferencesStatus.initial,
        );

  final Map<String, bool> togglesState;
  final NotificationPreferencesStatus status;

  @override
  List<Object?> get props => [togglesState, status];

  NotificationPreferencesState copyWith({
    Map<String, bool>? togglesState,
    NotificationPreferencesStatus? status,
  }) =>
      NotificationPreferencesState(
        togglesState: togglesState ?? this.togglesState,
        status: status ?? this.status,
      );
}
