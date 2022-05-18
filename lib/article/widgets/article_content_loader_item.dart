import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Renders a widget containing a progress indicator that calls
/// [onPresented] when the item becomes visible.
class ArticleContentLoaderItem extends StatefulWidget {
  const ArticleContentLoaderItem({super.key, this.onPresented});

  /// A callback performed when the widget is presented.
  final VoidCallback? onPresented;

  @override
  State<ArticleContentLoaderItem> createState() =>
      _ArticleContentLoaderItemState();
}

class _ArticleContentLoaderItemState extends State<ArticleContentLoaderItem> {
  @override
  void initState() {
    super.initState();
    widget.onPresented?.call();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
