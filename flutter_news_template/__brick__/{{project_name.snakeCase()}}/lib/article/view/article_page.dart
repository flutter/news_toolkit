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

/// The supported behaviors for interstitial ad.
enum InterstitialAdBehavior {
  /// Displays the ad when opening the article.
  onOpen,

  /// Displays the ad when closing the article.
  onClose,
}

class ArticlePage extends StatelessWidget {
  const ArticlePage({
    super.key,
    required this.id,
    required this.isVideoArticle,
    required this.interstitialAdBehavior,
  });

  /// The id of the requested article.
  final String id;

  /// Whether the requested article is a video article.
  final bool isVideoArticle;

  /// Indicates when the interstitial ad will be displayed.
  /// Default to [InterstitialAdBehavior.onOpen]
  final InterstitialAdBehavior interstitialAdBehavior;

  static Route<void> route({
    required String id,
    bool isVideoArticle = false,
    InterstitialAdBehavior interstitialAdBehavior =
        InterstitialAdBehavior.onOpen,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => ArticlePage(
          id: id,
          isVideoArticle: isVideoArticle,
          interstitialAdBehavior: interstitialAdBehavior,
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
        interstitialAdBehavior: interstitialAdBehavior,
      ),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    required this.isVideoArticle,
    required this.interstitialAdBehavior,
  });

  final bool isVideoArticle;
  final InterstitialAdBehavior interstitialAdBehavior;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isVideoArticle ? AppColors.darkBackground : AppColors.white;
    final foregroundColor =
        isVideoArticle ? AppColors.white : AppColors.highEmphasisSurface;
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

    return WillPopScope(
      onWillPop: () async {
        _onPop(context);
        return true;
      },
      child: HasToShowInterstitialAdListener(
        interstitialAdBehavior: interstitialAdBehavior,
        child: HasReachedArticleLimitListener(
          child: HasWatchedRewardedAdListener(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness:
                      isVideoArticle ? Brightness.light : Brightness.dark,
                  statusBarBrightness:
                      isVideoArticle ? Brightness.dark : Brightness.light,
                ),
                leading: isVideoArticle
                    ? AppBackButton.light(
                        onPressed: () => _onBackButtonPressed(context),
                      )
                    : AppBackButton(
                        onPressed: () => _onBackButtonPressed(context),
                      ),
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
                isVideoArticle: isVideoArticle,
                child: const ArticleContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBackButtonPressed(BuildContext context) {
    _onPop(context);
    Navigator.of(context).pop();
  }

  void _onPop(BuildContext context) {
    final state = context.read<ArticleBloc>().state;
    if (state.showInterstitialAd &&
        interstitialAdBehavior == InterstitialAdBehavior.onClose) {
      context
          .read<FullScreenAdsBloc>()
          .add(const ShowInterstitialAdRequested());
    }
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

@visibleForTesting
class HasToShowInterstitialAdListener extends StatelessWidget {
  const HasToShowInterstitialAdListener({
    super.key,
    required this.child,
    required this.interstitialAdBehavior,
  });

  final Widget child;

  final InterstitialAdBehavior interstitialAdBehavior;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state.showInterstitialAd &&
            interstitialAdBehavior == InterstitialAdBehavior.onOpen) {
          context
              .read<FullScreenAdsBloc>()
              .add(const ShowInterstitialAdRequested());
        }
      },
      listenWhen: (previous, current) =>
          previous.showInterstitialAd != current.showInterstitialAd,
      child: child,
    );
  }
}
