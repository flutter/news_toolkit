import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/widgets/sticky_ad.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_news_example/super_editor_article/banner_ad.dart';
import 'package:flutter_news_example/super_editor_article/divider.dart';
import 'package:flutter_news_example/super_editor_article/newsletter.dart';
import 'package:flutter_news_example/super_editor_article/share.dart';
import 'package:flutter_news_example/super_editor_article/slideshow.dart';
import 'package:flutter_news_example/super_editor_article/trending_story.dart';
import 'package:super_editor/super_editor.dart';

import 'news_document.dart';
import 'news_stylesheet.dart';
import 'spacer.dart';
import 'video.dart';

class SuperEditorArticle extends StatefulWidget {
  const SuperEditorArticle({super.key});

  @override
  State<SuperEditorArticle> createState() => _SuperEditorArticleState();
}

class _SuperEditorArticleState extends State<SuperEditorArticle> {
  @override
  Widget build(BuildContext context) {
    final content = context.select((ArticleBloc bloc) => bloc.state.content);
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);

    final onSharePressed = uri != null && uri.toString().isNotEmpty
        ? () => context.read<ArticleBloc>().add(
              ShareRequested(uri: uri),
            )
        : null;

    final document = createNewsDocument(
      context,
      content,
      onSharePressed: onSharePressed,
    );
    final stylesheet = createNewsStylesheet(context);

    return ArticleContentSeenListener(
      child: BlocListener<ArticleBloc, ArticleState>(
        listener: (context, state) {
          if (state.status == ArticleStatus.failure && state.content.isEmpty) {
            Navigator.of(context).push<void>(
              NetworkError.route(
                onRetry: () {
                  context.read<ArticleBloc>().add(const ArticleRequested());
                  Navigator.of(context).pop();
                },
              ),
            );
          } else if (state.status == ArticleStatus.shareFailure) {
            _handleShareFailure(context);
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SuperReader(
                    document: document,
                    componentBuilders: _componentBuilders,
                    stylesheet: stylesheet,
                  ),
                  const ArticleTrailingContent(),
                ],
              ),
            ),
            const StickyAd(),
          ],
        ),
      ),
    );
  }

  void _handleShareFailure(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('articleContent_shareFailure_snackBar'),
          content: Text(
            context.l10n.shareFailure,
          ),
        ),
      );
  }
}

final _componentBuilders = [
  ...defaultComponentBuilders,
  ShareComponentBuilder(),
  VideoComponentBuilder(),
  SlideshowComponentBuilder(),
  BannerAdComponentBuilder(),
  NewsletterComponentBuilder(),
  TrendingStoryComponentBuilder(),
  DividerComponentBuilder(),
  SpacerComponentBuilder(),
];
