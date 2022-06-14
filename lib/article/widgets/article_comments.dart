import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:google_news_template/l10n/l10n.dart';

//TODO (simpson-peter) do I need to add this to gallery?
class ArticleComments extends StatelessWidget {
  const ArticleComments({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.discussion,
          style: Theme.of(context).textTheme.headline3,
        ),
        const SizedBox(height: AppSpacing.lg),
        Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: const TextSelectionThemeData(
              selectionColor: Colors.transparent,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: context.l10n.commentEntryHint,
            ),
            showCursor: false,
          ),
        ),
      ],
    );
  }
}
