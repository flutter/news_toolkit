import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_repository/news_repository.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_event.dart';

class NotificationPreferencesBloc
    extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc({required List<Category> categories})
      : super(
          NotificationPreferencesState.initial(categories: categories),
        ) {
    on<NotificationPreferencesToggled>(_onNotificationPreferencesToggled);
  }

  FutureOr<void> _onNotificationPreferencesToggled(
    NotificationPreferencesToggled event,
    Emitter<NotificationPreferencesState> emit,
  ) {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    final updatedToggles = Map<Category, bool>.from(state.togglesState)
      ..update(event.category, (value) => !state.togglesState[event.category]!);
    // TODO(bselwe): Add FCM
    // notificationRepository.subscribeToTopic(event.category)
    emit(
      state.copyWith(
        status: NotificationPreferencesStatus.success,
        togglesState: updatedToggles,
      ),
    );
  }
}
