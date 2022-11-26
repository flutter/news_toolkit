import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:super_editor/super_editor.dart';

class BannerAdNode extends BlockNode with ChangeNotifier {
  BannerAdNode({
    required this.id,
    required this.size,
    required this.adFailedToLoadTitle,
  }) {
    metadata["blockType"] = bannerAdBlock;
  }

  @override
  final String id;
  final BannerAdSize size;
  final String adFailedToLoadTitle;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const bannerAdBlock = NamedAttribution("bannerAd");

class BannerAdComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! BannerAdNode) {
      return null;
    }

    return BannerAdViewModel(
      nodeId: node.id,
      size: node.size,
      adFailedToLoadTitle: node.adFailedToLoadTitle,
    );
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! BannerAdViewModel) {
      return null;
    }

    return BannerAdComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class BannerAdViewModel extends SingleColumnLayoutComponentViewModel {
  BannerAdViewModel({
    required super.nodeId,
    required this.size,
    required this.adFailedToLoadTitle,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  final BannerAdSize size;
  final String adFailedToLoadTitle;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return BannerAdViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      size: size,
      adFailedToLoadTitle: adFailedToLoadTitle,
    );
  }
}

class BannerAdComponent extends StatelessWidget {
  const BannerAdComponent({
    super.key,
    required this.viewModel,
  });

  final BannerAdViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BannerAdContainer(
      size: viewModel.size,
      child: BannerAdContent(
        size: viewModel.size,
        adFailedToLoadTitle: viewModel.adFailedToLoadTitle,
      ),
    );
  }
}
