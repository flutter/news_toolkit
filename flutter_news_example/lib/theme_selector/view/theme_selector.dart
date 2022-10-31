import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/theme_selector/theme_selector.dart';

/// A drop down menu to select a new [ThemeMode]
///
/// Requires a [ThemeModeBloc] to be provided in the widget tree
/// (usually above [MaterialApp])
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeMode = context.watch<ThemeModeBloc>().state;
    return DropdownButton(
      key: const Key('themeSelector_dropdown'),
      onChanged: (ThemeMode? selectedThemeMode) => context
          .read<ThemeModeBloc>()
          .add(ThemeModeChanged(selectedThemeMode)),
      value: themeMode,
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(
            l10n.systemOption,
            key: const Key('themeSelector_system_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(
            l10n.lightModeOption,
            key: const Key('themeSelector_light_dropdownMenuItem'),
          ),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(
            l10n.darkModeOption,
            key: const Key('themeSelector_dark_dropdownMenuItem'),
          ),
        ),
      ],
    );
  }
}
