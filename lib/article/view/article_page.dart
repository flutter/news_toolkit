import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_repository/news_repository.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.id});

  /// The id of the requested article.
  final String id;

  static Route route({required String id}) =>
      MaterialPageRoute<void>(builder: (_) => ArticlePage(id: id));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleBloc>(
      create: (_) => ArticleBloc(
        articleId: id,
        newsRepository: context.read<NewsRepository>(),
      )..add(ArticleRequested()),
      child: const ArticleView(),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({
    super.key,
    bool? isSubscriber,
  }) : _isSubscriber = isSubscriber ?? false;

  final bool _isSubscriber;

  @override
  Widget build(BuildContext context) {
    late PreferredSizeWidget appBar;
    if (_isSubscriber) {
      appBar = const PremiumAppBar();
    } else {
      appBar = const NotPremiumAppBar();
    }

    return Scaffold(
      appBar: appBar,
      body: const InterstitialAd(
        child: ArticleContent(),
      ),
    );
  }
}

@visibleForTesting
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: ShareButton(
            shareText: context.l10n.shareText,
            color: AppColors.highEmphasisSurface,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

@visibleForTesting
class NotPremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotPremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBackButton(),
      title: ShareButton(
        shareText: context.l10n.shareText,
        color: AppColors.highEmphasisSurface,
      ),
      actions: const [ArticleSubscribeButton()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
