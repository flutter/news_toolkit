import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileBloc(UserRepository userRepository) : super(UserProfileInitial()) {
    on<UserProfileUpdated>(_onUserProfileUpdated);

    _userSubscription = userRepository.user
        .handleError(addError)
        .listen((user) => add(UserProfileUpdated(user)));
  }

  late StreamSubscription<User> _userSubscription;

  void _onUserProfileUpdated(
    UserProfileUpdated event,
    Emitter<UserProfileState> emit,
  ) {
    emit(UserProfilePopulated(event.user));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
