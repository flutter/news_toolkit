part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}

class UserProfileUpdated extends UserProfileEvent {
  const UserProfileUpdated(this.user) : super();

  final User user;

  @override
  List<Object> get props => [user];
}

class FetchNotificationsEnabled extends UserProfileEvent {
  const FetchNotificationsEnabled();

  @override
  List<Object> get props => [];
}

class ToggleNotifications extends UserProfileEvent {
  const ToggleNotifications() : super();

  @override
  List<Object?> get props => [];
}
