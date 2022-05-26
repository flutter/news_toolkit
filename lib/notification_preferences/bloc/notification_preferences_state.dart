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
    required this.categories,
  });

  NotificationPreferencesState.initial({required List<Category> categories})
      : this(
          togglesState: {for (final category in categories) category: false},
          status: NotificationPreferencesStatus.initial,
          categories: categories,
        );

  final Map<Category, bool> togglesState;
  final NotificationPreferencesStatus status;
  final List<Category> categories;

  @override
  List<Object?> get props => [togglesState, status, categories];

  NotificationPreferencesState copyWith({
    Map<Category, bool>? togglesState,
    NotificationPreferencesStatus? status,
    List<Category>? categories,
  }) {
    final updatedToggles = categories == null
        ? togglesState ?? this.togglesState
        : {
            ...{for (final category in categories) category: false},
            ...togglesState ?? this.togglesState
          };
    return NotificationPreferencesState(
      togglesState: updatedToggles,
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}
