import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template content_theme_override_builder}
/// The builder widget that overrides the default [TextTheme]
/// to [AppTheme.contentTextTheme] in the widget tree
/// below the given [builder] widget.
/// {@endtemplate}
class ContentThemeOverrideBuilder extends StatelessWidget {
  /// {@macro content_theme_override_builder}
  const ContentThemeOverrideBuilder({required this.builder, super.key});

  /// The widget builder below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: AppTheme.contentTextTheme,
      ),
      child: Builder(builder: builder),
    );
  }
}
