import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final blocks = [
    PostMediumBlock(
      id: '82c49bf1-946d-4920-a801-302291f367b5',
      category: PostCategory.sports,
      author: 'Tom Dierberger',
      publishedAt: DateTime(2022, 3, 10),
      imageUrl:
          'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
      title: 'No Man’s Sky’s new Outlaws update '
          'lets players go full space pirate',
      description:
          'No Man’s Sky’s newest update, Outlaws, is now live, and it lets '
          'players find and smuggle black market goods and evade the'
          ' authorities in outlaw systems.',
      isContentOverlaid: true,
    ),
    PostMediumBlock(
      id: '82c49bf1-946d-4920-a801-302291f367b5',
      category: PostCategory.sports,
      author: 'Tom Dierberger',
      publishedAt: DateTime(2022, 3, 10),
      imageUrl:
          'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
      title: 'In Manchester, Calm Before a Stormy Summer',
      description:
          'Patrick Beverley is no longer participating in the NBA playoffs, '
          'but he sure has a lot to say. In Game 2 between the Warriors and '
          'Memphis Grizzlies on Tuesday night, Ja Morant torched the Dubs '
          'for 47 points...',
    ),
    PostMediumBlock(
      id: '82c49bf1-946d-4920-a801-302291f367b5',
      category: PostCategory.sports,
      author: 'Tom Dierberger',
      publishedAt: DateTime(2022, 3, 10),
      imageUrl:
          'https://www.nbcsports.com/sites/rsnunited/files/styles/metatags_opengraph/public/article/hero/pat-bev-ja-morant-USA.jpg',
      title:
          'No Man’s Sky’s new Outlaws update lets players go full space pirate',
      description:
          'Patrick Beverley is no longer participating in the NBA playoffs, '
          'but he sure has a lot to say. In Game 2 between the Warriors and '
          'Memphis Grizzlies on Tuesday night, Ja Morant torched the Dubs '
          'for 47 points...',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.dark(),
        centerTitle: true,
        actions: const [UserProfileButton()],
      ),
      drawer: const NavigationDrawer(),
      body: ContentThemeOverrideBuilder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: [for (var block in blocks) PostMedium(block: block)],
          ),
        ),
      ),
    );
  }
}
