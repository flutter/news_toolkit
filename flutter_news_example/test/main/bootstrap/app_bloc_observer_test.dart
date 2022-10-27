import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/main/bootstrap/app_bloc_observer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAnalyticsRepository extends Mock implements AnalyticsRepository {}

class FakeBloc extends Fake implements Bloc<dynamic, dynamic> {}

class TestAnalyticsEvent extends Equatable with AnalyticsEventMixin {
  @override
  AnalyticsEvent get event => const AnalyticsEvent('TestAnalyticsEvent');
}

class FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

void main() {
  group('AppBlocObserver', () {
    late Bloc<dynamic, dynamic> bloc;
    late AnalyticsRepository analyticsRepository;
    late AppBlocObserver observer;

    setUp(() {
      bloc = FakeBloc();
      analyticsRepository = MockAnalyticsRepository();
      when(() => analyticsRepository.track(any())).thenAnswer((_) async {});
      observer = AppBlocObserver(analyticsRepository: analyticsRepository);
    });

    setUpAll(() {
      registerFallbackValue(FakeAnalyticsEvent());
    });

    group('onTransition', () {
      test('returns normally', () {
        final transition = Transition(
          currentState: TestAnalyticsEvent(),
          event: TestAnalyticsEvent(),
          nextState: TestAnalyticsEvent(),
        );
        expect(() => observer.onTransition(bloc, transition), returnsNormally);
      });
    });

    group('onChange', () {
      test('tracks analytics event', () {
        final change = Change(
          currentState: TestAnalyticsEvent(),
          nextState: TestAnalyticsEvent(),
        );
        expect(() => observer.onChange(bloc, change), returnsNormally);
        verify(
          () => analyticsRepository.track(change.nextState.event),
        ).called(1);
      });
    });

    group('onEvent', () {
      test('tracks analytics event', () {
        final event = TestAnalyticsEvent();
        expect(() => observer.onEvent(bloc, event), returnsNormally);
        verify(() => analyticsRepository.track(event.event)).called(1);
      });
    });

    group('onError', () {
      test('returns normally', () {
        final error = Exception();
        const stackTrace = StackTrace.empty;
        expect(
          () => observer.onError(bloc, error, stackTrace),
          returnsNormally,
        );
      });
    });
  });
}
