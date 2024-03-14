import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template spacer}
/// A reusable spacer news block widget.
/// {@endtemplate}
class Spacer extends StatelessWidget {
  /// {@macro spacer}
  const Spacer({required this.block, super.key});

  /// The associated [SpacerBlock] instance.
  final SpacerBlock block;

  /// The spacing values of this spacer.
  static const _spacingValues = <Spacing, double>{
    Spacing.extraSmall: 4,
    Spacing.small: 8,
    Spacing.medium: 16,
    Spacing.large: 32,
    Spacing.veryLarge: 48,
    Spacing.extraLarge: 64,
  };

  @override
  Widget build(BuildContext context) {
    final spacing = _spacingValues.containsKey(block.spacing)
        ? _spacingValues[block.spacing]
        : 0.0;

    return SizedBox(
      width: double.infinity,
      height: spacing,
    );
  }
}
