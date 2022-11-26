import 'package:flutter/cupertino.dart';
import 'package:flutter_news_example/newsletter/newsletter.dart';
import 'package:super_editor/super_editor.dart';

class NewsletterNode extends BlockNode with ChangeNotifier {
  NewsletterNode({
    required this.id,
  }) {
    metadata["blockType"] = newsletterBlock;
  }

  @override
  final String id;

  @override
  String? copyContent(NodeSelection selection) {
    return null;
  }
}

const newsletterBlock = NamedAttribution("newsletter");

class NewsletterComponentBuilder extends ComponentBuilder {
  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! NewsletterNode) {
      return null;
    }

    return NewsletterViewModel(nodeId: node.id);
  }

  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! NewsletterViewModel) {
      return null;
    }

    return NewsletterComponent(
      key: componentContext.componentKey,
      viewModel: componentViewModel,
    );
  }
}

class NewsletterViewModel extends SingleColumnLayoutComponentViewModel {
  NewsletterViewModel({
    required super.nodeId,
    super.maxWidth,
    super.padding = EdgeInsets.zero,
  });

  @override
  SingleColumnLayoutComponentViewModel copy() {
    return NewsletterViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
    );
  }
}

class NewsletterComponent extends StatelessWidget {
  const NewsletterComponent({
    super.key,
    required this.viewModel,
  });

  final NewsletterViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return const Newsletter();
  }
}
