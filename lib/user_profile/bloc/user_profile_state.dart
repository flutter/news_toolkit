part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfilePopulated extends UserProfileState {
  const UserProfilePopulated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
