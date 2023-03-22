import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template section_header}
/// A reusable section header news block widget.
/// {@endtemplate}
class SectionHeader extends StatelessWidget {
  /// {@macro section_header}
  const SectionHeader({required this.block, this.onPressed, super.key});

  /// The associated [SectionHeaderBlock] instance.
  final SectionHeaderBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = Text(block.title, style: theme.textTheme.displaySmall);
    final action = block.action;
    final trailing = action != null
        ? IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => onPressed?.call(action),
          )
        : null;

    return ListTile(
      title: title,
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
    );
  }
}
