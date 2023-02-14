part of 'user_profile_bloc.dart';

enum UserProfileStatus {
  initial,
  fetchingNotificationsEnabled,
  fetchingNotificationsEnabledFailed,
  fetchingNotificationsEnabledSucceeded,
  togglingNotifications,
  togglingNotificationsFailed,
  togglingNotificationsSucceeded,
  userUpdated,
}

class UserProfileState extends Equatable {
  const UserProfileState({
    required this.status,
    required this.user,
    this.notificationsEnabled = false,
  });

  const UserProfileState.initial()
      : this(
          status: UserProfileStatus.initial,
          user: User.anonymous,
        );

  final UserProfileStatus status;
  final bool notificationsEnabled;
  final User user;

  @override
  List<Object?> get props => [status, user];

  UserProfileState copyWith({
    UserProfileStatus? status,
    bool? notificationsEnabled,
    User? user,
  }) =>
      UserProfileState(
        status: status ?? this.status,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        user: user ?? this.user,
      );
}
