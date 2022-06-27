import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/login/login.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/search/search.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) =>
          current.showLoginOverlay != previous.showLoginOverlay,
      listener: (context, state) {
        if (state.showLoginOverlay) {
          showAppModal<void>(
            context: context,
            builder: (context) => const LoginModal(),
            routeSettings: const RouteSettings(name: LoginModal.name),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppLogo.dark(),
          centerTitle: true,
          actions: const [UserProfileButton()],
        ),
        drawer: const NavigationDrawer(),
        body: IndexedStack(
          index: selectedTab,
          children: const [
            FeedView(),
            SearchPage(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: selectedTab,
          onTap: (value) => context.read<HomeCubit>().setTab(value),
        ),
      ),
    );
  }
}
