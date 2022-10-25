import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';
import 'package:{{project_name.snakeCase()}}/notification_preferences/notification_preferences.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => const NotificationPreferencesPage(),
    );
  }

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
                style: theme.textTheme.headline4,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.notificationPreferencesCategoriesSubtitle,
                style: theme.textTheme.bodyText1?.copyWith(
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
