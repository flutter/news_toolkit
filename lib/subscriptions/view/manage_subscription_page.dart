import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => const ManageSubscriptionPage(),
    );
  }

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
                style: theme.textTheme.headline4,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.manageSubscriptionBodyText,
                style: theme.textTheme.bodyText1?.copyWith(
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
                  style: theme.textTheme.subtitle2
                      ?.copyWith(color: AppColors.darkAqua),
                ),
                onTap: () {
                  context.read<AppBloc>().add(
                        const AppUserSubscriptionPlanChanged(
                          SubscriptionPlan.none,
                        ),
                      );
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
