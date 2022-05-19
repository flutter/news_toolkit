import 'package:flutter/material.dart';

class CategoriesTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoriesTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Text(categoryName.toUpperCase());
  }
}
