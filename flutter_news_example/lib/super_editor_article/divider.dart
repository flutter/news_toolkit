import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

class DividerNode extends BlockNode with ChangeNotifier {
  DividerNode({
    required this.id,
  }) {
    metadata["blockType"] = dividerBlock;
  }

  @override
  final String id;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const dividerBlock = NamedAttribution("divider");

class DividerComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! DividerNode) {
      return null;
    }

    return DividerViewModel(nodeId: node.id);
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! DividerViewModel) {
      return null;
    }

    return DividerComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class DividerViewModel extends SingleColumnLayoutComponentViewModel {
  DividerViewModel({
    required super.nodeId,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return DividerViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class DividerComponent extends StatelessWidget {
  const DividerComponent({
    super.key,
    required this.viewModel,
  });

  final DividerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Divider();
  }
}
