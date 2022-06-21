import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart' as flutter_html;

import 'package:news_blocks/news_blocks.dart';

/// {@template html}
/// A reusable html news block widget.
/// {@endtemplate}
class Html extends StatelessWidget {
  /// {@macro html}
  const Html({super.key, required this.block});

  /// The associated [HtmlBlock] instance.
  final HtmlBlock block;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: flutter_html.Html(data: block.content),
    );
  }
}
