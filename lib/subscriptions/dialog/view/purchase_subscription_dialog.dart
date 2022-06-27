import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/subscriptions/subscriptions.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';

Future<void> showPurchaseSubscriptionDialog({
  required BuildContext context,
}) async =>
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => const PurchaseSubscriptionDialog(),
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
                            showDialog<void>(
                              context: context,
                              builder: (context) => const PurchaseCompleted(),
                            ).then((_) => Navigator.maybePop(context));
                          }
                        },
                        builder: (context, state) {
                          if (state.subscriptions.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.subscriptions.length,
                              itemBuilder: (context, index) => SubscriptionCard(
                                key: ValueKey(state.subscriptions[index]),
                                subscription: state.subscriptions[index],
                                isExpanded: index == 0,
                              ),
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
class PurchaseCompleted extends StatefulWidget {
  const PurchaseCompleted({super.key});

  @override
  State<PurchaseCompleted> createState() => _PurchaseCompletedState();
}

class _PurchaseCompletedState extends State<PurchaseCompleted> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(
      const Duration(seconds: 3),
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
    super.dispose();
    _timer.cancel();
  }
}
