import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/notification_preferences/notification_preferences.dart';
import 'package:notification_preferences_repository/notification_preferences_repository.dart';

class NotificationPreferencesPage extends StatelessWidget {
  const NotificationPreferencesPage({super.key});

  static MaterialPageRoute<void> route() {
    return MaterialPageRoute(
      builder: (_) => const NotificationPreferencesView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationPreferencesBloc(
        categories:
            context.read<CategoriesBloc>().state.categories?.toSet() ?? {},
        notificationPreferencesRepository:
            context.read<NotificationPreferencesRepository>(),
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.userProfileSettingsNotificationPreferencesTitle,
            style: theme.textTheme.headline4,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.userProfileSettingsNotificationPreferencesCategoriesSubtitle,
            style: theme.textTheme.bodyText1,
          ),
          BlocBuilder<NotificationPreferencesBloc,
              NotificationPreferencesState>(
            builder: (context, state) => Expanded(
              child: ListView(
                children: state.categories
                    .map<Widget>(
                      (category) => NotificationCategoryTile(
                        title: category.name,
                        trailing: AppSwitch(
                          onText: l10n.userProfileCheckboxOnTitle,
                          offText: l10n.userProfileCheckboxOffTitle,
                          value: state.selectedCategories.contains(category),
                          onChanged: (value) =>
                              context.read<NotificationPreferencesBloc>().add(
                                    NotificationPreferencesToggled(
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
    );
  }
}
