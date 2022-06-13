import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:share_launcher/share_launcher.dart';

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
        shareLauncher: const ShareLauncher(),
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
    required this.isVideoArticle,
  });

  final bool isVideoArticle;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isVideoArticle ? AppColors.darkBackground : AppColors.white;
    final foregroundColor =
        isVideoArticle ? AppColors.white : AppColors.highEmphasisSurface;
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

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
        actions: [
          if (uri != null && uri.toString().isNotEmpty)
            Padding(
              key: const Key('articlePage_shareButton'),
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: ShareButton(
                shareText: context.l10n.shareText,
                color: foregroundColor,
                onPressed: () =>
                    context.read<ArticleBloc>().add(ShareRequested(uri: uri)),
              ),
            ),
          if (!isSubscriber) const ArticleSubscribeButton()
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
