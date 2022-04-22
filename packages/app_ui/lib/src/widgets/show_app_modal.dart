import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Modal which is styled for the Google news template app.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet(
    context: context,
    builder: builder,
    isScrollControlled: true,
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    elevation: elevation,
    constraints: constraints,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppSpacing.lg),
        topRight: Radius.circular(AppSpacing.lg),
      ),
    ),
    clipBehavior: Clip.hardEdge,
  );
}
