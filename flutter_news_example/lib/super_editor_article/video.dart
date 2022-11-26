import 'package:flutter/widgets.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:super_editor/super_editor.dart';

class VideoNode extends BlockNode with ChangeNotifier {
  VideoNode({
    required this.id,
    required this.videoUrl,
  });

  @override
  final String id;

  final String videoUrl;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

class VideoComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! VideoNode) {
      return null;
    }

    return VideoViewModel(nodeId: node.id, videoUrl: node.videoUrl);
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! VideoViewModel) {
      return null;
    }

    return VideoComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class VideoViewModel extends SingleColumnLayoutComponentViewModel {
  VideoViewModel({
    required super.nodeId,
    required this.videoUrl,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  final String videoUrl;

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return VideoViewModel(
      nodeId: nodeId,
      videoUrl: videoUrl,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class VideoComponent extends StatelessWidget {
  const VideoComponent({
    super.key,
    required this.viewModel,
  });

  final VideoViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return InlineVideo(
      videoUrl: viewModel.videoUrl,
      progressIndicator: const ProgressIndicator(),
    );
  }
}
