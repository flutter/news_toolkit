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
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// The static news feed content.
    final _technologyPost = PostLargeBlock(
      id: '499305f6-5096-4051-afda-824dcfc7df23',
      category: PostCategory.technology,
      author: 'Sean Hollister',
      publishedAt: DateTime(2022, 3, 9),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      title: 'Nvidia and AMD GPUs are returning to shelves '
          'and prices are finally falling',
    );
    final _technologyPost2 = PostLargeBlock(
      id: '499305f6-5096-4051-afda-824dcfc7df23',
      category: PostCategory.technology,
      author: 'Sean Hollister',
      publishedAt: DateTime(2022, 3, 9),
      imageUrl:
          'https://cdn.vox-cdn.com/thumbor/OTpmptgr7XcTVAJ27UBvIxl0vrg=/0x146:2040x1214/fit-in/1200x630/cdn.vox-cdn.com/uploads/chorus_asset/file/22049166/shollister_201117_4303_0003.0.jpg',
      title: 'Nvidia and AMD GPUs are returning to shelves '
          'and prices are finally falling',
      isContentOverlaid: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: AppLogo.dark(),
        centerTitle: true,
        actions: const [UserProfileButton()],
      ),
      drawer: const NavigationDrawer(),
      body: Center(
        child: ContentThemeOverrideBuilder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                PostLarge(block: _technologyPost, premiumText: 'Premium'),
                PostLarge(block: _technologyPost2, premiumText: 'Premium')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
