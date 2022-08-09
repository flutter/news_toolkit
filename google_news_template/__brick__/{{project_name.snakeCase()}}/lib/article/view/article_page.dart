import 'package:app_ui/app_ui.dart';
import 'package:article_repository/article_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/ads/ads.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/article/article.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/subscriptions/subscriptions.dart';
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
      )..add(const ArticleRequested()),
      child: ArticleView(
        isVideoArticle: isVideoArticle,
      ),
    );
  }
}

class ArticleView extends StatefulWidget {
  const ArticleView({
    super.key,
    required this.isVideoArticle,
  });

  final bool isVideoArticle;

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  @override
  void initState() {
    context.read<FullScreenAdsBloc>().add(const ShowInterstitialAdRequested());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.isVideoArticle ? AppColors.darkBackground : AppColors.white;
    final foregroundColor =
        widget.isVideoArticle ? AppColors.white : AppColors.highEmphasisSurface;
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

    return HasReachedArticleLimitListener(
      child: HasWatchedRewardedAdListener(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness:
                  widget.isVideoArticle ? Brightness.light : Brightness.dark,
              statusBarBrightness:
                  widget.isVideoArticle ? Brightness.dark : Brightness.light,
            ),
            leading: widget.isVideoArticle
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
                    onPressed: () => context
                        .read<ArticleBloc>()
                        .add(ShareRequested(uri: uri)),
                  ),
                ),
              if (!isSubscriber) const ArticleSubscribeButton()
            ],
          ),
          body: ArticleThemeOverride(
            isVideoArticle: widget.isVideoArticle,
            child: const ArticleContent(),
          ),
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
          onPressed: () => showPurchaseSubscriptionDialog(context: context),
          child: Text(context.l10n.subscribeButtonText),
        ),
      ),
    );
  }
}

@visibleForTesting
class HasReachedArticleLimitListener extends StatelessWidget {
  const HasReachedArticleLimitListener({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (!state.hasReachedArticleViewsLimit) {
          context.read<ArticleBloc>().add(const ArticleRequested());
        }
      },
      listenWhen: (previous, current) =>
          previous.hasReachedArticleViewsLimit !=
          current.hasReachedArticleViewsLimit,
      child: child,
    );
  }
}

@visibleForTesting
class HasWatchedRewardedAdListener extends StatelessWidget {
  const HasWatchedRewardedAdListener({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FullScreenAdsBloc, FullScreenAdsState>(
      listener: (context, state) {
        if (state.earnedReward != null) {
          context.read<ArticleBloc>().add(const ArticleRewardedAdWatched());
        }
      },
      listenWhen: (previous, current) =>
          previous.earnedReward != current.earnedReward,
      child: child,
    );
  }
}
