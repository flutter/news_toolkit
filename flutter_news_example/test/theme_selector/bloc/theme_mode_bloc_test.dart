import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/theme_selector/theme_selector.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  initMockHydratedStorage();

  group('ThemeModeBloc', () {
    test('initial state is ThemeMode.system', () {
      expect(ThemeModeBloc().state, ThemeMode.system);
    });

    blocTest<ThemeModeBloc, ThemeMode>(
      'on ThemeModeChanged sets the ThemeMode',
      build: ThemeModeBloc.new,
      act: (bloc) => bloc.add(const ThemeModeChanged(ThemeMode.dark)),
      expect: () => [ThemeMode.dark],
    );

    test('toJson and fromJson are inverse', () {
      for (final mode in ThemeMode.values) {
        final bloc = ThemeModeBloc();
        expect(bloc.fromJson(bloc.toJson(mode)), mode);
      }
    });
  });
}
