import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Spacer;

class ArticleComments extends StatelessWidget {
  const ArticleComments({
    super.key,
    required this.title,
    this.hintText = '',
  });

  final String title;

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(height: AppSpacing.lg),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
              // TODO (simpson-peter) what color should this be?
              selectionColor: Colors.transparent,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hintText,
            ),
            showCursor: false,
          ),
        ),
      ],
    );
  }
}
