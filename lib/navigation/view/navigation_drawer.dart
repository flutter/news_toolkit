import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  static const _contentPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Drawer(
        backgroundColor: AppColors.darkBackground,
        child: ScrollableColumn(
          padding: const EdgeInsets.only(
            top: kToolbarHeight,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _contentPadding,
                18,
                _contentPadding,
                18,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppLogo.light(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _contentPadding,
              ),
              child: AppDivider(),
            ),
          ],
        ),
      ),
    );
  }
}
