import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SubscribeLoggedIn extends StatelessWidget {
  const SubscribeLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppColors.darkBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '_Subscribe today for\nunlimited access.',
            style: theme.textTheme.headline3?.apply(color: AppColors.white),
          ),
          const SizedBox(height: 10),
          Text(
            '_Subscribe to get unlimited access\nto all of our content on any device.',
            style: theme.textTheme.subtitle1
                ?.apply(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: 32),
          AppButton.redWine(
            child: const Text('_Subscribe'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
