import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeCubit', () {
    group('constructor', () {
      test('has correct initial state', () async {
        expect(
          HomeCubit().state,
          equals(HomeState.topStories),
        );
      });
    });

    group('setTab', () {
      blocTest<HomeCubit, HomeState>(
        'sets tab on top stories',
        build: HomeCubit.new,
        act: (cubit) => cubit.setTab(0),
        expect: () => [
          HomeState.topStories,
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'sets tab on search',
        build: HomeCubit.new,
        act: (cubit) => cubit.setTab(1),
        expect: () => [
          HomeState.search,
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'sets tab on subscribe',
        build: HomeCubit.new,
        act: (cubit) => cubit.setTab(2),
        expect: () => [
          HomeState.subscribe,
        ],
      );
    });
  });
}
