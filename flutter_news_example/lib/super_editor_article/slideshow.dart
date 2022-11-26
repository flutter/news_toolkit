import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:super_editor/super_editor.dart';

class SlideshowNode extends BlockNode with ChangeNotifier {
  SlideshowNode({
    required this.id,
    required this.coverImageUrl,
    required this.slideshowText,
    required this.title,
  }) {
    metadata["blockType"] = slideshowBlock;
  }

  @override
  final String id;

  final String coverImageUrl;
  final String slideshowText;
  final String title;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const slideshowBlock = NamedAttribution("slideshow");

class SlideshowComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! SlideshowNode) {
      return null;
    }

    return SlideshowViewModel(
      nodeId: node.id,
      coverImageUrl: node.coverImageUrl,
      slideshowText: node.slideshowText,
      title: node.title,
    );
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! SlideshowViewModel) {
      return null;
    }

    return SlideshowComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class SlideshowViewModel extends SingleColumnLayoutComponentViewModel {
  SlideshowViewModel({
    required super.nodeId,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
    required this.coverImageUrl,
    required this.slideshowText,
    required this.title,
  });

  final String coverImageUrl;
  final String slideshowText;
  final String title;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return SlideshowViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      coverImageUrl: coverImageUrl,
      slideshowText: slideshowText,
      title: title,
    );
  }
}

class SlideshowComponent extends StatelessWidget {
  const SlideshowComponent({
    super.key,
    required this.viewModel,
  });

  final SlideshowViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        // TODO:
      },
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          PostLargeImage(
            imageUrl: viewModel.coverImageUrl,
            isContentOverlaid: true,
            isLocked: false,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideshowCategory(slideshowText: viewModel.slideshowText),
                const SizedBox(
                  height: AppSpacing.xs,
                ),
                Text(
                  viewModel.title,
                  style: textTheme.headline2?.copyWith(
                    color: AppColors.highEmphasisPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
