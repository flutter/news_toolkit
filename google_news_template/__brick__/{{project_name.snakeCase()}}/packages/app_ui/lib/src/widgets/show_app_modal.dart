import 'package:flutter/material.dart';

/// Modal which is styled for the {{app_name}} app.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
  double? elevation,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet(
    context: context,
    builder: builder,
    routeSettings: routeSettings,
    constraints: constraints,
    isScrollControlled: true,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    transitionAnimationController: transitionAnimationController,
    elevation: elevation,
  );
}
