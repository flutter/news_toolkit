import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart' as analytics;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'analytics_event.dart';
part 'analytics_state.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  AnalyticsBloc({
    required analytics.AnalyticsRepository analyticsRepository,
    required UserRepository userRepository,
  })  : _analyticsRepository = analyticsRepository,
        super(AnalyticsInitial()) {
    on<TrackAnalyticsEvent>(_onTrackAnalyticsEvent);

    _userSubscription = userRepository.user.listen(_onUserChanged);
  }

  final analytics.AnalyticsRepository _analyticsRepository;
  late StreamSubscription<User> _userSubscription;

  Future<void> _onUserChanged(User user) async {
    try {
      await _analyticsRepository
          .setUserId(user != User.anonymous ? user.id : null);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onTrackAnalyticsEvent(
    TrackAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    try {
      await _analyticsRepository.track(event.event);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
