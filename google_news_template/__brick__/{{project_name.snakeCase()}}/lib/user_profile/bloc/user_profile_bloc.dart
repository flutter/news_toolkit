import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc({
    required UserRepository userRepository,
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(const UserProfileState.initial()) {
    on<UserProfileUpdated>(_onUserProfileUpdated);
    on<FetchNotificationsEnabled>(_onFetchNotificationsEnabled);
    on<ToggleNotifications>(_onToggleNotifications);

    _userSubscription = userRepository.user
        .handleError(addError)
        .listen((user) => add(UserProfileUpdated(user)));
  }

  final NotificationsRepository _notificationsRepository;
  late StreamSubscription<User> _userSubscription;

  void _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<UserProfileState> emit,
  ) {
    emit(
      state.copyWith(
        user: event.user,
        status: UserProfileStatus.userUpdated,
      ),
    );
  }

  FutureOr<void> _onFetchNotificationsEnabled(
    FetchNotificationsEnabled event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: UserProfileStatus.fetchingNotificationsEnabled,
        ),
      );

      final notificationsEnabled =
          await _notificationsRepository.fetchNotificationsEnabled();

      emit(
        state.copyWith(
          status: UserProfileStatus.fetchingNotificationsEnabledSucceeded,
          notificationsEnabled: notificationsEnabled,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: UserProfileStatus.fetchingNotificationsEnabledFailed,
        ),
      );
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onToggleNotifications(
    ToggleNotifications event,
    Emitter<UserProfileState> emit,
  ) async {
    final initialNotificationsEnabled = state.notificationsEnabled;
    final updatedNotificationsEnabled = !initialNotificationsEnabled;

    try {
      emit(
        state.copyWith(
          status: UserProfileStatus.togglingNotifications,
          notificationsEnabled: updatedNotificationsEnabled,
        ),
      );

      await _notificationsRepository.toggleNotifications(
        enable: updatedNotificationsEnabled,
      );

      emit(
        state.copyWith(
          status: UserProfileStatus.togglingNotificationsSucceeded,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: UserProfileStatus.togglingNotificationsFailed,
          notificationsEnabled: initialNotificationsEnabled,
        ),
      );
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
