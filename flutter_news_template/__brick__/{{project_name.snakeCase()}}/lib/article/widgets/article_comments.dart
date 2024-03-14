import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart' hide Spacer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';

class ArticleComments extends StatelessWidget {
  const ArticleComments({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.discussion,
          style: Theme.of(context).textTheme.displaySmall,
          key: const Key('articleComments_discussionTitle'),
        ),
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 148,
          ),
          child: AppTextField(
            hintText: context.l10n.commentEntryHint,
            onSubmitted: (_) {
              final articleBloc = context.read<ArticleBloc>();
              articleBloc.add(
                ArticleCommented(articleTitle: articleBloc.state.title!),
              );
            },
          ),
        ),
      ],
    );
  }
}
