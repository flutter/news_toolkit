import 'package:app_ui/app_ui.dart' show AppColors, AppLogo, AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static const _contentPadding = AppSpacing.lg;

  @override
  Widget build(BuildContext context) {
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(AppSpacing.lg),
        bottomRight: Radius.circular(AppSpacing.lg),
      ),
      child: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ListView(
          physics: const ClampingScrollPhysics(),
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
            const _NavDrawerDivider(),
            const NavDrawerSections(),
            if (!isUserSubscribed) ...[
              const _NavDrawerDivider(),
              const NavDrawerSubscribe(),
            ],
          ],
        ),
      ),
    );
  }
}

class _NavDrawerDivider extends StatelessWidget {
  const _NavDrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(color: AppColors.outlineOnDark);
  }
}
