import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_mode_event.dart';

/// Keeps track of and allows changing the application's [ThemeMode].
class ThemeModeBloc extends HydratedBloc<ThemeModeEvent, ThemeMode> {
  /// Create a new object
  ThemeModeBloc() : super(ThemeMode.system) {
    on<ThemeModeChanged>((event, emit) => emit(event.themeMode ?? state));
  }

  @override
  ThemeMode fromJson(Map<dynamic, dynamic> json) =>
      ThemeMode.values[json['theme_mode'] as int];

  @override
  Map<String, int> toJson(ThemeMode state) => {'theme_mode': state.index};
}
