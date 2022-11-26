import 'package:flutter/widgets.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:super_editor/super_editor.dart';

class SpacerNode extends BlockNode with ChangeNotifier {
  SpacerNode({
    required this.id,
    required this.spacing,
  });

  @override
  final String id;

  final Spacing spacing;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

class SpacerViewModel extends SingleColumnLayoutComponentViewModel {
  SpacerViewModel({
    required super.nodeId,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
    required this.spacing,
  });

  final Spacing spacing;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return SpacerViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      spacing: spacing,
    );
  }
}

class SpacerComponentBuilder implements ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! SpacerNode) {
      return null;
    }

    return SpacerViewModel(
      nodeId: node.id,
      spacing: node.spacing,
    );
  }

  @override
  Widget? createComponent(
    SingleColumnDocumentComponentContext componentContext,
    SingleColumnLayoutComponentViewModel componentViewModel,
  ) {
    if (componentViewModel is! SpacerViewModel) {
      return null;
    }

    return SpacerComponent(
      key: componentContext.componentKey,
      spacing: componentViewModel.spacing,
    );
  }
}

class SpacerComponent extends StatelessWidget {
  static const _spacingValues = <Spacing, double>{
    Spacing.extraSmall: 4,
    Spacing.small: 8,
    Spacing.medium: 16,
    Spacing.large: 32,
    Spacing.veryLarge: 48,
    Spacing.extraLarge: 64,
  };

  const SpacerComponent({
    super.key,
    required this.spacing,
  });

  final Spacing spacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _spacingValues[spacing],
    );
  }
}
