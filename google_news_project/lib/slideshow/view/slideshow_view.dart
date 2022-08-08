import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class SlideshowView extends StatelessWidget {
  const SlideshowView({
    super.key,
    required this.block,
  });

  final SlideshowBlock block;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton.light(),
        actions: [
          Row(
            children: [
              if (uri != null && uri.toString().isNotEmpty)
                Padding(
                  key: const Key('slideshowPage_shareButton'),
                  padding: const EdgeInsets.only(right: AppSpacing.lg),
                  child: ShareButton(
                    shareText: context.l10n.shareText,
                    color: AppColors.white,
                    onPressed: () {
                      context.read<ArticleBloc>().add(ShareRequested(uri: uri));
                    },
                  ),
                ),
              if (!isSubscriber) const ArticleSubscribeButton()
            ],
          )
        ],
      ),
      backgroundColor: AppColors.darkBackground,
      body: Slideshow(
        block: block,
        categoryTitle: l10n.slideshow.toUpperCase(),
        navigationLabel: l10n.slideshow_of_title,
      ),
    );
  }
}
