import 'package:flutter/material.dart';

class CategoriesTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoriesTabBar({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 48);
}

class CategoryTab extends StatelessWidget {
  const CategoryTab({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Text(categoryName.toUpperCase());
  }
}
