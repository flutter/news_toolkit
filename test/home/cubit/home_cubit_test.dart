import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/home/home.dart';

import '../../helpers/mock_hydrated_storage.dart';

void main() {
  group('HomeCubit', () {
    late HomeCubit homeCubit;
    setUp(() async {
      homeCubit = await mockHydratedStorage(HomeCubit.new);
    });
    group('constructor', () {
      test('has correct initial state', () async {
        expect(
          homeCubit.state,
          equals(HomeState.topStories),
        );
      });
    });

    group('setTab', () {
      blocTest<HomeCubit, HomeState>(
        'sets tab on top stories',
        build: () => homeCubit,
        act: (cubit) => cubit.setTab(0),
        expect: () => [
          HomeState.topStories,
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'sets tab on search',
        build: () => homeCubit,
        act: (cubit) => cubit.setTab(1),
        expect: () => [
          HomeState.search,
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'sets tab on subscribe',
        build: () => homeCubit,
        act: (cubit) => cubit.setTab(2),
        expect: () => [
          HomeState.subscribe,
        ],
      );
    });
  });
}
