import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:super_editor/super_editor.dart';

class ShareNode extends BlockNode with ChangeNotifier {
  ShareNode({
    required this.id,
    required this.shareText,
    this.onSharePressed,
  }) {
    metadata["blockType"] = shareBlock;
  }

  @override
  final String id;
  final String shareText;
  final VoidCallback? onSharePressed;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const shareBlock = NamedAttribution("share");

class ShareComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! ShareNode) {
      return null;
    }

    return ShareViewModel(
      nodeId: node.id,
      shareText: node.shareText,
      onSharePressed: node.onSharePressed,
    );
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! ShareViewModel) {
      return null;
    }

    return ShareComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class ShareViewModel extends SingleColumnLayoutComponentViewModel {
  ShareViewModel({
    required super.nodeId,
    required this.shareText,
    this.onSharePressed,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  final String shareText;
  final VoidCallback? onSharePressed;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return ShareViewModel(
      nodeId: nodeId,
      shareText: shareText,
      onSharePressed: onSharePressed,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class ShareComponent extends StatelessWidget {
  const ShareComponent({
    super.key,
    required this.viewModel,
  });

  final ShareViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        if (viewModel.onSharePressed != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Align(
              alignment: Alignment.centerRight,
              child: ShareButton(
                key: const Key('articleIntroduction_shareButton'),
                shareText: viewModel.shareText,
                color: AppColors.darkAqua,
                onPressed: viewModel.onSharePressed!,
              ),
            ),
          ),
        const Divider(),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
