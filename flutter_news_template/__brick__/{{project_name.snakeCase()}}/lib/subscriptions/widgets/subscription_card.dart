import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/login/login.dart';
import 'package:{{project_name.snakeCase()}}/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:intl/intl.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    required this.subscription,
    this.isExpanded = false,
    this.isBestValue = false,
    super.key,
  });

  final bool isExpanded;
  final bool isBestValue;
  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final monthlyCost = NumberFormat.currency(
      decimalDigits: subscription.cost.monthly % 100 == 0 ? 0 : 2,
      symbol: r'$',
    ).format(subscription.cost.monthly / 100);
    final annualCost = NumberFormat.currency(
      decimalDigits: subscription.cost.annual % 100 == 0 ? 0 : 2,
      symbol: r'$',
    ).format(
      subscription.cost.annual / 100,
    );
    final isLoggedIn = context.select<AppBloc, bool>(
      (AppBloc bloc) => bloc.state.status.isLoggedIn,
    );

    return Card(
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: AppColors.borderOutline,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xlg + AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: AppSpacing.xlg + AppSpacing.sm,
            ),
            Text(
              subscription.name.name.toUpperCase(),
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: AppColors.secondary),
            ),
            Text(
              '$monthlyCost/${l10n.monthAbbreviation} | $annualCost/${l10n.yearAbbreviation}',
              style: theme.textTheme.headlineSmall,
            ),
            if (isBestValue) ...[
              Assets.icons.bestValue
                  .svg(key: const Key('subscriptionCard_bestValueSvg')),
              const SizedBox(height: AppSpacing.md),
            ],
            if (isExpanded) ...[
              const Divider(indent: 0, endIndent: 0),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.subscriptionPurchaseBenefits.toUpperCase(),
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
            for (final paragraph in subscription.benefits)
              ListTile(
                key: ValueKey(paragraph),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                ),
                horizontalTitleGap: 0,
                leading: const Icon(
                  Icons.check,
                  color: AppColors.mediumHighEmphasisSurface,
                ),
                title: Text(
                  paragraph,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.mediumHighEmphasisSurface,
                  ),
                ),
              ),
            if (isExpanded) ...[
              const Divider(indent: 0, endIndent: 0),
              const SizedBox(height: AppSpacing.md),
              Align(
                child: Text(
                  l10n.subscriptionPurchaseCancelAnytime,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.mediumHighEmphasisSurface,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton.smallRedWine(
                key: const Key('subscriptionCard_subscribe_appButton'),
                onPressed: isLoggedIn
                    ? () => context.read<SubscriptionsBloc>().add(
                          SubscriptionPurchaseRequested(
                            subscription: subscription,
                          ),
                        )
                    : () => showAppModal<void>(
                          context: context,
                          builder: (_) => const LoginModal(),
                          routeSettings:
                              const RouteSettings(name: LoginModal.name),
                        ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoggedIn)
                      Text(l10n.subscriptionPurchaseButton)
                    else
                      Text(l10n.subscriptionUnauthenticatedPurchaseButton)
                  ],
                ),
              ),
            ] else
              AppButton.smallOutlineTransparent(
                key: const Key('subscriptionCard_viewDetails_appButton'),
                onPressed: () => ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      key: const Key(
                        'subscriptionCard_unimplemented_snackBar',
                      ),
                      content: Text(
                        l10n.subscriptionViewDetailsButtonSnackBar,
                      ),
                    ),
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(l10n.subscriptionViewDetailsButton)],
                ),
              ),
            const SizedBox(height: AppSpacing.lg + AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
