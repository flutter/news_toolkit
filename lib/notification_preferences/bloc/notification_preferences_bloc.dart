import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notification_preferences_repository/notification_preferences_repository.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_event.dart';

class NotificationPreferencesBloc
    extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc({
    required Set<Category> categories,
    required this.notificationPreferencesRepository,
  }) : super(
          NotificationPreferencesState.initial(categories: categories),
        ) {
    on<NotificationPreferencesToggled>(_onNotificationPreferencesToggled);
  }

  final NotificationPreferencesRepository notificationPreferencesRepository;

  FutureOr<void> _onNotificationPreferencesToggled(
    NotificationPreferencesToggled event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    final updatedCategories = Set<Category>.from(state.selectedCategories);

    updatedCategories.contains(event.category)
        ? updatedCategories.remove(event.category)
        : updatedCategories.add(event.category);

    await notificationPreferencesRepository
        .setCategoriesPreferences(updatedCategories);

    emit(
      state.copyWith(
        status: NotificationPreferencesStatus.success,
        selectedCategories: updatedCategories,
      ),
    );
  }
}
