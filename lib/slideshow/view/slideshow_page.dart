import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/slideshow/slideshow.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class SlideshowPage extends StatelessWidget {
  const SlideshowPage({
    super.key,
    required this.slideshow,
  });

  static Route route({required SlideshowBlock slideshow}) {
    return MaterialPageRoute<void>(
      builder: (_) => SlideshowPage(slideshow: slideshow),
    );
  }

  final SlideshowBlock slideshow;

  @override
  Widget build(BuildContext context) {
    // final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    final isSubscriber =
        context.select<AppBloc, bool>((bloc) => bloc.state.isUserSubscribed);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton.light(),
        actions: [
          Row(
            children: [
              // if (uri != null && uri.toString().isNotEmpty)
              Padding(
                key: const Key('slideshowPage_shareButton'),
                padding: const EdgeInsets.only(right: AppSpacing.lg),
                child: ShareButton(
                  shareText: context.l10n.shareText,
                  color: AppColors.white,
                  onPressed: () {
                    // context.read<ArticleBloc>().add(ShareRequested(uri: uri)),
                  },
                ),
              ),
              if (!isSubscriber) const ArticleSubscribeButton()
            ],
          )
        ],
      ),
      backgroundColor: AppColors.darkBackground,
      body: SlideshowView(
        block: slideshow,
      ),
    );
  }
}
