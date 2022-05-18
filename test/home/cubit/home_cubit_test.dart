import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/home/home.dart';

void main() {
  group('HomeCubit', () {
    HomeCubit buildCubit() => HomeCubit();

    group('constructor', () {
      test('works properly', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(const HomeState()),
        );
      });
    });

    group('setTab', () {
      blocTest<HomeCubit, HomeState>(
        'sets tab on search',
        build: buildCubit,
        act: (cubit) => cubit.setTab(1),
        expect: () => [
          const HomeState(selectedIndex: 1),
        ],
      );

      blocTest<HomeCubit, HomeState>(
        'sets tab on subscribe',
        build: buildCubit,
        act: (cubit) => cubit.setTab(2),
        expect: () => [
          const HomeState(selectedIndex: 2),
        ],
      );
    });
  });
}
