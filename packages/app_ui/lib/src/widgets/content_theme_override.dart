import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template content_theme_override}
/// The widget that overrides the default [TextTheme]
/// to [AppTheme.contentTextTheme] in the widget tree
/// below the given [child] widget.
/// {@endtemplate}
class ContentThemeOverride extends StatelessWidget {
  /// {@macro content_theme_override}
  const ContentThemeOverride({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        textTheme: AppTheme.contentTextTheme,
      ),
      child: child,
    );
  }
}
