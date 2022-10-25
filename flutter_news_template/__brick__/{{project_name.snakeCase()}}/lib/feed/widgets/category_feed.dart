import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/feed/feed.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:news_repository/news_repository.dart';

class CategoryFeed extends StatelessWidget {
  const CategoryFeed({
    super.key,
    required this.category,
    this.scrollController,
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

    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.failure) {
          _handleFailure(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => context
            .read<FeedBloc>()
            .add(FeedRefreshRequested(category: category)),
        displacement: 0,
        color: AppColors.mediumHighEmphasisSurface,
        child: ListView.builder(
          itemCount: categoryFeed.length + 1,
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index == categoryFeed.length) {
              return hasMoreNews
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

            final block = categoryFeed[index];
            return CategoryFeedItem(block: block);
          },
        ),
      ),
    );
  }

  void _handleFailure(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('categoryFeed_failure_snackBar'),
          content: Text(
            context.l10n.unexpectedFailure,
          ),
        ),
      );
  }
}
