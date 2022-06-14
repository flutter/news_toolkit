import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/l10n/l10n.dart';

class ArticleTrailingContent extends StatelessWidget {
  const ArticleTrailingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final relatedArticles =
        context.select((ArticleBloc bloc) => bloc.state.relatedArticles);
    return Column(
      key: const Key('articleTrailingContent_column'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (relatedArticles.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(
              context.l10n.relatedStories,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...relatedArticles
              .map((articleBlock) => CategoryFeedItem(block: articleBlock)),
        ],
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ArticleComments(
            // (simpson-peter) TODO internationalize
            title: 'Discussion',
            // (simpson-peter) TODO internationalize
            hintText: 'Enter comment',
          ),
        ),
      ],
    );
  }
}
