import 'package:flutter/widgets.dart';

/// {@template scrollable_column}
/// Creates a scrollable vertical array of children.
///
/// The [mainAxisAlignment], [mainAxisSize], [crossAxisAlignment], and
/// [verticalDirection] arguments must not be null.
/// If [crossAxisAlignment] is [CrossAxisAlignment.baseline], then
/// [textBaseline] must not be null.
///
/// The [textDirection] argument defaults to the ambient [Directionality], if
/// any. If there is no ambient directionality, and a text direction is going
/// to be necessary to disambiguate `start` or `end` values for the
/// [crossAxisAlignment], the [textDirection] must not be null.
/// {@endtemplate}
class ScrollableColumn extends StatelessWidget {
  /// {@macro scrollable_column}
  const ScrollableColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.padding,
  });

  /// The children of the underlying [Column].
  final List<Widget> children;

  /// The cross axis alignment of the underlying [Column].
  final CrossAxisAlignment crossAxisAlignment;

  /// The text direction of the underlying [Column].
  final TextDirection? textDirection;

  /// The main axis alignment of the underlying [Column].
  final MainAxisAlignment mainAxisAlignment;

  /// The main axis size of the underlying [Column].
  final MainAxisSize mainAxisSize;

  /// The vertical direction of the underlying [Column].
  final VerticalDirection verticalDirection;

  /// The text baseline of the underlying [Column].
  final TextBaseline? textBaseline;

  /// The padding of the underlying [Column].
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  textDirection: textDirection,
                  mainAxisAlignment: mainAxisAlignment,
                  mainAxisSize: mainAxisSize,
                  verticalDirection: verticalDirection,
                  textBaseline: textBaseline,
                  children: children,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
