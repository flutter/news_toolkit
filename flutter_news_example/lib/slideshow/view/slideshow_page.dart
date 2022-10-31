import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/slideshow/slideshow.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:share_launcher/share_launcher.dart';

class SlideshowPage extends StatelessWidget {
  const SlideshowPage({
    super.key,
    required this.slideshow,
    required this.articleId,
  });

  static Route<void> route({
    required SlideshowBlock slideshow,
    required String articleId,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => SlideshowPage(
        slideshow: slideshow,
        articleId: articleId,
      ),
    );
  }

  final SlideshowBlock slideshow;
  final String articleId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArticleBloc(
        articleId: articleId,
        shareLauncher: const ShareLauncher(),
        articleRepository: context.read<ArticleRepository>(),
      ),
      child: SlideshowView(
        block: slideshow,
      ),
    );
  }
}
