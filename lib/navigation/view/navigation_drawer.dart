import 'package:app_ui/app_ui.dart' show AppColors, AppSpacing, AppLogo;
import 'package:flutter/material.dart';
import 'package:google_news_template/navigation/navigation.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  static const _contentPadding = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppSpacing.lg),
        bottomRight: Radius.circular(AppSpacing.lg),
      ),
      child: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
            top: kToolbarHeight,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.xlg,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: _contentPadding + AppSpacing.xxs,
                horizontal: _contentPadding,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppLogo.light(),
              ),
            ),
            const _NavigationDrawerDivider(),
            const NavigationDrawerSections(),
            const _NavigationDrawerDivider(),
            const NavigationDrawerSubscribe(),
          ],
        ),
      ),
    );
  }
}

class _NavigationDrawerDivider extends StatelessWidget {
  const _NavigationDrawerDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ),
      child: Opacity(
        opacity: 0.16,
        child: Divider(),
      ),
    );
  }
}
