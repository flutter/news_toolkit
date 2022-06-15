import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:google_news_template/l10n/l10n.dart';

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
          key: const Key('articleComments_discussionTitle'),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          hintText: context.l10n.commentEntryHint,
        ),
      ],
    );
  }
}
