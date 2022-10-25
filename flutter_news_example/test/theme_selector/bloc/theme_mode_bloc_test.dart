import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/theme_selector/theme_selector.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ThemeModeBloc', () {
    late ThemeModeBloc themeModeBloc;

    setUp(() async {
      themeModeBloc = await mockHydratedStorage(ThemeModeBloc.new);
    });

    test('initial state is ThemeMode.system', () {
      mockHydratedStorage(() {
        expect(ThemeModeBloc().state, ThemeMode.system);
      });
    });

    blocTest<ThemeModeBloc, ThemeMode>(
      'on ThemeModeChanged sets the ThemeMode',
      build: () => themeModeBloc,
      act: (bloc) => bloc.add(const ThemeModeChanged(ThemeMode.dark)),
      expect: () => [ThemeMode.dark],
    );

    test('toJson and fromJson are inverse', () {
      mockHydratedStorage(() {
        for (final mode in ThemeMode.values) {
          final bloc = ThemeModeBloc();
          expect(bloc.fromJson(bloc.toJson(mode)), mode);
        }
      });
    });
  });
}
