import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  static const routePath = 'notification-preferences';

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const NotificationPreferencesPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationPreferencesBloc>(
      create: (_) => NotificationPreferencesBloc(
        newsRepository: context.read<NewsRepository>(),
        notificationsRepository: context.read<NotificationsRepository>(),
      )..add(InitialCategoriesPreferencesRequested()),
      child: const NotificationPreferencesView(),
    );
  }
}

@visibleForTesting
class NotificationPreferencesView extends StatelessWidget {
  const NotificationPreferencesView({super.key});

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
                l10n.notificationPreferencesTitle,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.notificationPreferencesCategoriesSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.mediumEmphasisSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<NotificationPreferencesBloc,
                  NotificationPreferencesState>(
                builder: (context, state) => Expanded(
                  child: ListView(
                    children: state.categories
                        .map<Widget>(
                          (category) => NotificationCategoryTile(
                            title: category.name,
                            trailing: AppSwitch(
                              onText: l10n.checkboxOnTitle,
                              offText: l10n.userProfileCheckboxOffTitle,
                              value:
                                  state.selectedCategories.contains(category),
                              onChanged: (value) => context
                                  .read<NotificationPreferencesBloc>()
                                  .add(
                                    CategoriesPreferenceToggled(
                                      category: category,
                                    ),
                                  ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
