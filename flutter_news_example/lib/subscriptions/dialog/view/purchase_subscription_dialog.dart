import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/analytics/analytics.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<void> showPurchaseSubscriptionDialog({
  required BuildContext context,
}) async =>
    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => const PurchaseSubscriptionDialog(),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: const Offset(0, 1), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );

class PurchaseSubscriptionDialog extends StatelessWidget {
  const PurchaseSubscriptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionsBloc>(
      create: (context) => SubscriptionsBloc(
        inAppPurchaseRepository: context.read<InAppPurchaseRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(SubscriptionsRequested()),
      child: const PurchaseSubscriptionDialogView(),
    );
  }
}

class PurchaseSubscriptionDialogView extends StatelessWidget {
  const PurchaseSubscriptionDialogView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Scaffold(
          body: Dialog(
            insetPadding: EdgeInsets.zero,
            backgroundColor: AppColors.modalBackground,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.subscriptionPurchaseTitle,
                          style: theme.textTheme.headline3,
                        ),
                        IconButton(
                          key: const Key(
                            'purchaseSubscriptionDialog_closeIconButton',
                          ),
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Text(
                      l10n.subscriptionPurchaseSubtitle,
                      style: theme.textTheme.subtitle1,
                    ),
                    const SizedBox(height: AppSpacing.xlg),
                    Expanded(
                      child:
                          BlocConsumer<SubscriptionsBloc, SubscriptionsState>(
                        listener: (context, state) {
                          if (state.purchaseStatus ==
                              PurchaseStatus.completed) {
                            context.read<AnalyticsBloc>().add(
                                  TrackAnalyticsEvent(
                                    UserSubscriptionConversionEvent(),
                                  ),
                                );
                            showDialog<void>(
                              context: context,
                              builder: (context) =>
                                  const PurchaseCompletedDialog(),
                            ).then((_) => Navigator.maybePop(context));
                          }
                        },
                        builder: (context, state) {
                          if (state.subscriptions.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return CustomScrollView(
                              slivers: <SliverList>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) => SubscriptionCard(
                                      key: ValueKey(state.subscriptions[index]),
                                      subscription: state.subscriptions[index],
                                      isExpanded: index == 0,
                                    ),
                                    childCount: state.subscriptions.length,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

@visibleForTesting
class PurchaseCompletedDialog extends StatefulWidget {
  const PurchaseCompletedDialog({super.key});

  @override
  State<PurchaseCompletedDialog> createState() =>
      _PurchaseCompletedDialogState();
}

class _PurchaseCompletedDialogState extends State<PurchaseCompletedDialog> {
  late Timer _timer;

  static const _closeDialogAfterDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      _closeDialogAfterDuration,
      () => Navigator.maybePop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.xxlg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.md),
              const Icon(
                Icons.check_circle_outline,
                size: AppSpacing.xxlg + AppSpacing.xxlg,
                color: AppColors.mediumEmphasisSurface,
              ),
              const SizedBox(height: AppSpacing.xlg),
              Text(
                context.l10n.subscriptionPurchaseCompleted,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
