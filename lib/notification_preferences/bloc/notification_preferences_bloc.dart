import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_event.dart';

class NotificationPreferencesBloc
    extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc({
    required this.newsRepository,
  }) : super(NotificationPreferencesState.initial()) {
    on<NotificationPreferencesToggled>(_onNotificationPreferencesToggled);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
  }

  final NewsRepository newsRepository;

  FutureOr<void> _onNotificationPreferencesToggled(
    NotificationPreferencesToggled event,
    Emitter<NotificationPreferencesState> emit,
  ) {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));
    try {
      final updatedToggles = Map<String, bool>.from(state.togglesState)
        ..update(
          event.preference,
          (value) => !state.togglesState[event.preference]!,
          ifAbsent: () => true,
        );
      // TODO(bselwe): Add FCM
      // notificationRepository.subscribeToTopic(event.preference)
      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          togglesState: updatedToggles,
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotificationPreferencesStatus.failure));
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));
    try {
      final categories = await newsRepository.getCategories();

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          togglesState: {
            for (var element in categories.categories) element.name: false
          },
        ),
      );
    } catch (error, stackTrace) {
      emit(state.copyWith(status: NotificationPreferencesStatus.failure));
      addError(error, stackTrace);
    }
  }
}
