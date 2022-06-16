import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:news_blocks/news_blocks.dart';

class FeedView extends StatelessWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoriesBloc bloc) => bloc.state.categories) ?? [];

    if (categories.isEmpty) {
      return const SizedBox(
        key: Key('feedView_empty'),
      );
    }

    return FeedViewPopulated(categories: categories);
  }
}

@visibleForTesting
class FeedViewPopulated extends StatefulWidget {
  const FeedViewPopulated({
    super.key,
    required this.categories,
  });

  final List<Category> categories;

  @override
  State<FeedViewPopulated> createState() => _FeedViewPopulatedState();
}

class _FeedViewPopulatedState extends State<FeedViewPopulated>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.categories.length,
      vsync: this,
    )..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() => context
      .read<CategoriesBloc>()
      .add(CategorySelected(category: widget.categories[_tabController.index]));

  final _scrossController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        final selectedCategory = state.selectedCategory;
        if (selectedCategory != null) {
          final selectedCategoryIndex =
              widget.categories.indexOf(selectedCategory);
          if (selectedCategoryIndex != -1 &&
              selectedCategoryIndex != _tabController.index) {
            _tabController
                .animateTo(widget.categories.indexOf(selectedCategory));
          }
        }
      },
      listenWhen: (previous, current) =>
          previous.selectedCategory != current.selectedCategory,
      child: Column(
        children: [
          CategoriesTabBar(
            controller: _tabController,
            tabs: widget.categories
                .map(
                  (category) => CategoryTab(
                    categoryName: category.name,
                    onDoubleTap: () {
                      _scrossController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.categories
                  .map(
                    (category) => CategoryFeed(
                      key: PageStorageKey(category),
                      category: category,
                      scrollController: _scrossController,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
