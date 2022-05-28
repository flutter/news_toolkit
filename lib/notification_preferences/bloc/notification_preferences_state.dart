part of 'notification_preferences_bloc.dart';

enum NotificationPreferencesStatus {
  initial,
  loading,
  success,
  failure,
}

class NotificationPreferencesState extends Equatable {
  const NotificationPreferencesState({
    required this.selectedCategories,
    required this.status,
    required this.categories,
  });

  NotificationPreferencesState.initial({required Set<Category> categories})
      : this(
          selectedCategories: categories.toSet(),
          status: NotificationPreferencesStatus.initial,
          categories: categories,
        );

  final NotificationPreferencesStatus status;
  final Set<Category> categories;
  final Set<Category> selectedCategories;

  @override
  List<Object?> get props => [selectedCategories, status, categories];

  NotificationPreferencesState copyWith({
    Set<Category>? selectedCategories,
    NotificationPreferencesStatus? status,
    Set<Category>? categories,
  }) {
    return NotificationPreferencesState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      status: status ?? this.status,
      categories: categories ?? this.categories,
    );
  }
}
