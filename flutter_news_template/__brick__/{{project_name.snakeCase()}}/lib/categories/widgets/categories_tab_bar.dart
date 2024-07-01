import 'package:flutter/material.dart';

class CategoriesTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoriesTabBar({
    required this.controller,
    required this.tabs,
    super.key,
  });

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: controller,
      isScrollable: true,
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    required this.categoryName,
    this.onDoubleTap,
    super.key,
  });

  final String categoryName;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      child: Text(categoryName.toUpperCase()),
    );
  }
}
