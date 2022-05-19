import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

@visibleForTesting
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final Function(int value) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: context.l10n.bottomNavBarTopStories,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: context.l10n.bottomNavBarSearch,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.subscriptions_outlined),
          label: context.l10n.bottomNavBarSubscribe,
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
