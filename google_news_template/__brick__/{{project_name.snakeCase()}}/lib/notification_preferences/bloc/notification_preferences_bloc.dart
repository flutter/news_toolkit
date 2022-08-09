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
    required NewsRepository newsRepository,
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        _newsRepository = newsRepository,
        super(
          NotificationPreferencesState.initial(),
        ) {
    on<CategoriesPreferenceToggled>(
      _onCategoriesPreferenceToggled,
    );
    on<InitialCategoriesPreferencesRequested>(
      _onInitialCategoriesPreferencesRequested,
    );
  }

  final NotificationsRepository _notificationsRepository;
  final NewsRepository _newsRepository;

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
      late Set<Category> selectedCategories;
      late CategoriesResponse categoriesResponse;

      await Future.wait(
        [
          (() async => selectedCategories =
              await _notificationsRepository.fetchCategoriesPreferences() ??
                  {})(),
          (() async =>
              categoriesResponse = await _newsRepository.getCategories())(),
        ],
      );

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          selectedCategories: selectedCategories,
          categories: categoriesResponse.categories.toSet(),
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
