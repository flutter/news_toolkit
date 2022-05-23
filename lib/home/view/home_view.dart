import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/navigation/navigation.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.tabIndex);
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: const [
          FeedView(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedTab,
        onTap: (value) => context.read<HomeCubit>().setTab(value),
      ),
    );
  }
}
