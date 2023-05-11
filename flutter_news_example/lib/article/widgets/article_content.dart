import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_news_example_api/client.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((ArticleBloc bloc) => bloc.state.status);

    final hasMoreContent =
        context.select((ArticleBloc bloc) => bloc.state.hasMoreContent);

    if (status == ArticleStatus.initial) {
      return const ArticleContentLoaderItem(
        key: Key('articleContent_empty_loaderItem'),
      );
    }

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
            SelectionArea(
              child: CustomScrollView(
                slivers: [
                  const ArticleContentItemList(),
                  if (!hasMoreContent) const ArticleTrailingContent(),
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

class ArticleContentSeenListener extends StatelessWidget {
  const ArticleContentSeenListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) => context.read<AnalyticsBloc>().add(
            TrackAnalyticsEvent(
              ArticleMilestoneEvent(
                milestonePercentage: state.contentMilestone,
                articleTitle: state.title!,
              ),
            ),
          ),
      listenWhen: (previous, current) =>
          previous.contentMilestone != current.contentMilestone,
      child: child,
    );
  }
}

class ArticleContentItemList extends StatelessWidget {
  const ArticleContentItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final isFailure = context.select(
      (ArticleBloc bloc) => bloc.state.status == ArticleStatus.failure,
    );
    final hasMoreContent =
        context.select((ArticleBloc bloc) => bloc.state.hasMoreContent);

    final status = context.select((ArticleBloc bloc) => bloc.state.status);
    final content = context.select((ArticleBloc bloc) => bloc.state.content);
    final uri = context.select((ArticleBloc bloc) => bloc.state.uri);
    final isArticlePreview =
        context.select((ArticleBloc bloc) => bloc.state.isPreview);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == content.length) {
            if (isFailure) {
              return NetworkError(
                onRetry: () {
                  context.read<ArticleBloc>().add(const ArticleRequested());
                },
              );
            }
            return hasMoreContent
                ? Padding(
                    padding: EdgeInsets.only(
                      top: content.isEmpty ? AppSpacing.xxxlg : 0,
                    ),
                    child: ArticleContentLoaderItem(
                      key: const Key(
                        'articleContent_moreContent_loaderItem',
                      ),
                      onPresented: () {
                        if (status != ArticleStatus.loading) {
                          context
                              .read<ArticleBloc>()
                              .add(const ArticleRequested());
                        }
                      },
                    ),
                  )
                : const SizedBox();
          }

          return _buildArticleItem(
            context,
            index,
            content,
            uri,
            isArticlePreview,
          );
        },
        childCount: content.length + 1,
      ),
    );
  }

  Widget _buildArticleItem(
    BuildContext context,
    int index,
    List<NewsBlock> content,
    Uri? uri,
    bool isArticlePreview,
  ) {
    final block = content[index];
    final isFinalItem = index == content.length - 1;

    final visibilityDetectorWidget = VisibilityDetector(
      key: ValueKey(block),
      onVisibilityChanged: (visibility) {
        if (!visibility.visibleBounds.isEmpty) {
          context
              .read<ArticleBloc>()
              .add(ArticleContentSeen(contentIndex: index));
        }
      },
      child: ArticleContentItem(
        block: block,
        onSharePressed: uri != null && uri.toString().isNotEmpty
            ? () => context.read<ArticleBloc>().add(
                  ShareRequested(uri: uri),
                )
            : null,
      ),
    );
    return isFinalItem && isArticlePreview
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [visibilityDetectorWidget, const ArticleTrailingShadow()],
          )
        : visibilityDetectorWidget;
  }
}
