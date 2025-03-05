import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  static const routePath = 'manage-subscription';

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const ManageSubscriptionPage();

  @override
  Widget build(BuildContext context) {
    return const ManageSubscriptionView();
  }
}

@visibleForTesting
class ManageSubscriptionView extends StatelessWidget {
  const ManageSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.manageSubscriptionTile,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.manageSubscriptionBodyText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.mediumEmphasisSurface,
                ),
              ),
              ListTile(
                key: const Key('manageSubscription_subscriptions'),
                dense: true,
                horizontalTitleGap: 0,
                leading: const Icon(
                  Icons.open_in_new,
                  color: AppColors.darkAqua,
                ),
                title: Text(
                  l10n.manageSubscriptionLinkText,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: AppColors.darkAqua),
                ),
                onTap: () {
                  // No possibility to revoke subscriptions from the app.
                  // Navigate the user to "Manage Subscriptions" page instead.
                  Navigator.maybePop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
