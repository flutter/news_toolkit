import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:super_editor/super_editor.dart';

class TrendingStoryNode extends BlockNode with ChangeNotifier {
  TrendingStoryNode({
    required this.id,
    required this.title,
    required this.content,
  }) {
    metadata["blockType"] = trendingStoryBlock;
  }

  @override
  final String id;
  final String title;
  final PostSmallBlock content;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const trendingStoryBlock = NamedAttribution("trendingStory");

class TrendingStoryComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! TrendingStoryNode) {
      return null;
    }

    return TrendingStoryViewModel(
      nodeId: node.id,
      title: node.title,
      content: node.content,
    );
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! TrendingStoryViewModel) {
      return null;
    }

    return TrendingStoryComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class TrendingStoryViewModel extends SingleColumnLayoutComponentViewModel {
  TrendingStoryViewModel({
    required super.nodeId,
    required this.title,
    required this.content,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  final String title;
  final PostSmallBlock content;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return TrendingStoryViewModel(
      nodeId: nodeId,
      title: title,
      content: content,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class TrendingStoryComponent extends StatelessWidget {
  const TrendingStoryComponent({
    super.key,
    required this.viewModel,
  });

  final TrendingStoryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            top: AppSpacing.md,
          ),
          child: Text(
            viewModel.title,
            style: theme.overline?.apply(color: AppColors.secondary),
          ),
        ),
        PostSmall(block: viewModel.content)
      ],
    );
  }
}
