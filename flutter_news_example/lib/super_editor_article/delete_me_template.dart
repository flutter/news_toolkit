import 'package:flutter/cupertino.dart';
import 'package:super_editor/super_editor.dart';

class DeleteMeNode extends BlockNode with ChangeNotifier {
  DeleteMeNode({
    required this.id,
  });

  @override
  final String id;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

class DeleteMeComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! DeleteMeNode) {
      return null;
    }

    return DeleteMeViewModel(nodeId: node.id);
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! DeleteMeViewModel) {
      return null;
    }

    return DeleteMeComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class DeleteMeViewModel extends SingleColumnLayoutComponentViewModel {
  DeleteMeViewModel({
    required super.nodeId,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return DeleteMeViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class DeleteMeComponent extends StatelessWidget {
  const DeleteMeComponent({
    super.key,
    required this.viewModel,
  });

  final DeleteMeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
