import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories =
        context.select((CategoriesBloc bloc) => bloc.state.categories) ?? [];

    if (categories.isEmpty) {
      return const SizedBox();
    }

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.dark(),
          centerTitle: true,
          actions: const [UserProfileButton()],
          bottom: CategoriesTabBar(
            tabs: categories
                .map((category) => CategoryTab(categoryName: category.name))
                .toList(),
          ),
        ),
        drawer: const NavigationDrawer(),
        body: TabBarView(
          children: categories
              .map(
                (category) => CategoryFeed(
                  key: PageStorageKey(category),
                  category: category,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
