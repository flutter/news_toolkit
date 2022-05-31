import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_event.dart';

class NotificationPreferencesBloc
    extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc({
    required Set<Category> categories,
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(
          NotificationPreferencesState.initial(categories: categories),
        ) {
    on<CategoriesPreferenceToggled>(
      _onCategoriesPreferenceToggled,
    );
    on<InitialCategoriesPreferencesRequested>(
      _onInitialCategoriesPreferencesRequested,
    );
  }

  final NotificationsRepository _notificationsRepository;

  FutureOr<void> _onCategoriesPreferenceToggled(
    CategoriesPreferenceToggled event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    final updatedCategories = Set<Category>.from(state.selectedCategories);

    updatedCategories.contains(event.category)
        ? updatedCategories.remove(event.category)
        : updatedCategories.add(event.category);

    try {
      await _notificationsRepository
          .setCategoriesPreferences(updatedCategories);

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          selectedCategories: updatedCategories,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(status: NotificationPreferencesStatus.failure),
      );
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onInitialCategoriesPreferencesRequested(
    InitialCategoriesPreferencesRequested event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    try {
      final selectedCategories =
          await _notificationsRepository.fetchCategoriesPreferences();

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          selectedCategories: selectedCategories,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(status: NotificationPreferencesStatus.failure),
      );
      addError(error, stackTrace);
    }
  }
}
