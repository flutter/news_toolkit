import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.id,
    required this.isVideoArticle,
  });

  /// The id of the requested article.
  final String id;

  /// Whether the requested article is a video article.
  final bool isVideoArticle;

  static Route route({
    required String id,
    bool isVideoArticle = false,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => ArticlePage(
          id: id,
          isVideoArticle: isVideoArticle,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleBloc>(
      create: (_) => ArticleBloc(
        articleId: id,
        articleRepository: context.read<ArticleRepository>(),
      )..add(ArticleRequested()),
      child: ArticleView(
        isVideoArticle: isVideoArticle,
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    this.isSubscriber = false,
    required this.isVideoArticle,
  });

  final bool isSubscriber;
  final bool isVideoArticle;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isVideoArticle ? AppColors.darkBackground : AppColors.white;
    final foregroundColor =
        isVideoArticle ? AppColors.white : AppColors.highEmphasisSurface;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness:
              isVideoArticle ? Brightness.light : Brightness.dark,
          statusBarBrightness:
              isVideoArticle ? Brightness.dark : Brightness.light,
        ),
        leading: isVideoArticle
            ? const AppBackButton.light()
            : const AppBackButton(),
        title: isSubscriber
            ? const SizedBox()
            : ShareButton(
                shareText: context.l10n.shareText,
                color: foregroundColor,
              ),
        actions: [
          if (isSubscriber)
            Padding(
              key: const Key('articlePage_shareButton'),
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: ShareButton(
                shareText: context.l10n.shareText,
                color: foregroundColor,
              ),
            )
          else
            const ArticleSubscribeButton()
        ],
      ),
      body: InterstitialAd(
        child: ArticleThemeOverride(
          isVideoArticle: isVideoArticle,
          child: const ArticleContent(),
        ),
      ),
    );
  }
}

@visibleForTesting
class ArticleSubscribeButton extends StatelessWidget {
  const ArticleSubscribeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: Align(
        alignment: Alignment.centerRight,
        child: AppButton.smallRedWine(
          onPressed: () {},
          child: Text(context.l10n.subscribeButtonText),
        ),
      ),
    );
  }
}
