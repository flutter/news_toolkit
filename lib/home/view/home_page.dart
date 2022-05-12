import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:google_news_template_api/client.dart';
import 'package:news_repository/news_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.dark(),
        centerTitle: true,
        actions: const [UserProfileButton()],
      ),
      drawer: const NavigationDrawer(),
      body: BlocProvider(
        create: (context) => FeedBloc(
          newsRepository: context.read<NewsRepository>(),
        )..add(const FeedRequested(category: Category.top)),
        child: const CustomScrollView(
          slivers: [
            SliverToBoxAdapter(),
            CategoryFeed(
              category: Category.top,
            ),
          ],
        ),
      ),
    );
  }
}
