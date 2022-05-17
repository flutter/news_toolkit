import 'package:flutter/material.dart';

/// {@template social_navigation_bar}
/// A reusable row of navigationTargets.
/// {@endtemplate}
class SocialNavigationBar extends StatelessWidget {
  /// {@macro social_navigation_bar}
  const SocialNavigationBar({
    super.key,
    required this.navigationTargets,
  });

  /// The array of navigation targets
  final List<Widget> navigationTargets;

  @override
  Widget build(BuildContext context) {
    return Row(children: navigationTargets);
  }
}
