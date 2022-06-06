import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/ads/ads.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/subscribe/subscribe.dart';

class ArticleContent extends StatefulWidget {
  const ArticleContent({super.key});

  @override
  State<ArticleContent> createState() => _ArticleContentState();
}

class _ArticleContentState extends State<ArticleContent> {
  late ScrollController _controller;
  var _showModal = false;
  final isSubscribed = false;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    final maxPixels = MediaQuery.of(context).size.height * .5;
    final reachedBottom = _controller.position.pixels >= maxPixels;

    if (reachedBottom && !isSubscribed) {
      setState(() => _showModal = true);
      _controller.jumpTo(maxPixels);
    } else {
      setState(() => _showModal = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = context.select((ArticleBloc bloc) => bloc.state.status);
    final content = context.select((ArticleBloc bloc) => bloc.state.content);
    final hasMoreContent =
        context.select((ArticleBloc bloc) => bloc.state.hasMoreContent);

    if (status == ArticleStatus.initial || status == ArticleStatus.loading) {
      return const ArticleContentLoaderItem(
        key: Key('articleContent_empty_loaderItem'),
      );
    }

    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state.status == ArticleStatus.failure) {
          _handleFailure(context);
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ListView.builder(
            controller: _controller,
            itemCount: content.length + 1,
            itemBuilder: (context, index) {
              if (index == content.length) {
                return hasMoreContent
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: content.isEmpty ? AppSpacing.xxxlg : 0,
                        ),
                        child: ArticleContentLoaderItem(
                          key: ValueKey(index),
                          onPresented: () => context
                              .read<ArticleBloc>()
                              .add(ArticleRequested()),
                        ),
                      )
                    : const SizedBox();
              }

              final block = content[index];
              return ArticleContentItem(block: block);
            },
          ),
          SubscribeWhiteShadow(
            show: _showModal,
            child: const SubscribeLoggedIn(),
          ),
          AnimatedOpacity(
            opacity: _showModal ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: _showModal,
              child: const StickyAd(),
            ),
          )
        ],
      ),
    );
  }

  void _handleFailure(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('articleContent_failure_snackBar'),
          content: Text(
            context.l10n.unexpectedFailure,
          ),
        ),
      );
  }
}
