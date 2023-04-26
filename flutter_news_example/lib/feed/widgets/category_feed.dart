import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_news_example_api/client.dart';

class CategoryFeed extends StatelessWidget {
  const CategoryFeed({
    required this.category,
    this.scrollController,
    super.key,
  });

  final Category category;

  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final categoryFeed =
        context.select((FeedBloc bloc) => bloc.state.feed[category]) ?? [];

    final hasMoreNews =
        context.select((FeedBloc bloc) => bloc.state.hasMoreNews[category]) ??
            true;

    final isFailure = context
        .select((FeedBloc bloc) => bloc.state.status == FeedStatus.failure);

    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.failure && state.feed.isEmpty) {
          Navigator.of(context).push<void>(
            NetworkError.route(
              onRetry: () {
                context
                    .read<FeedBloc>()
                    .add(FeedRefreshRequested(category: category));
                Navigator.of(context).pop();
              },
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => context
            .read<FeedBloc>()
            .add(FeedRefreshRequested(category: category)),
        displacement: 0,
        color: AppColors.mediumHighEmphasisSurface,
        child: SelectionArea(
          child: CustomScrollView(
            controller: scrollController,
            slivers: _buildSliverItems(
              context,
              categoryFeed,
              hasMoreNews,
              isFailure,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSliverItems(
    BuildContext context,
    List<NewsBlock> categoryFeed,
    bool hasMoreNews,
    bool isFailure,
  ) {
    final sliverList = <Widget>[];
    // All fetchs of the feed are triggered by the CategoryFeedLoaderItem.
    // The previous code used ListView.builder, and it had
    // itemCount: feedList + 1.
    // This caused that the CategoryFeedLoaderItem widget always rendered,
    // thus the initial fetch always got triggered.
    // Now we are using CustomScrollView, and it does not have a builder
    // constructor. To avoid making even more changes to the code
    // I just translated the behaviour to an indexed for, so that the
    // CategoryFeedLoaderItem can be rendered and the initial fetch can
    // get triggered.
    // I do believe it'd be nice to refactor this at some point in time.

    for (var index = 0; index < categoryFeed.length + 1; index++) {
      late Widget result;
      if (index == categoryFeed.length) {
        if (isFailure) {
          result = NetworkError(
            onRetry: () {
              context
                  .read<FeedBloc>()
                  .add(FeedRefreshRequested(category: category));
            },
          );
        }
        result = hasMoreNews
            ? Padding(
                padding: EdgeInsets.only(
                  top: categoryFeed.isEmpty ? AppSpacing.xxxlg : 0,
                ),
                child: CategoryFeedLoaderItem(
                  key: ValueKey(index),
                  onPresented: () => context
                      .read<FeedBloc>()
                      .add(FeedRequested(category: category)),
                ),
              )
            : const SizedBox();
      }

      if (categoryFeed.isEmpty || index == categoryFeed.length) {
        sliverList.add(SliverToBoxAdapter(child: result));
      } else {
        final block = categoryFeed[index];
        sliverList.add(CategoryFeedItem(block: block, constructAsSliver: true));
      }
    }

    return sliverList;
  }
}
