import 'package:app_ui/app_ui.dart'
    show AppBackButton, AppButton, AppColors, AppSpacing, AppSwitch, Assets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_news_example/terms_of_service/terms_of_service.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:user_repository/user_repository.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  static const routePath = 'profile';

  static Widget routeBuilder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const UserProfilePage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileBloc(
        userRepository: context.read<UserRepository>(),
        notificationsRepository: context.read<NotificationsRepository>(),
      ),
      child: const UserProfileView(),
    );
  }
}

@visibleForTesting
class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<UserProfileBloc>().add(const FetchNotificationsEnabled());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Fetch current notification status each time a user enters the app.
    // This may happen when a user changes permissions in app settings.
    if (state == AppLifecycleState.resumed) {
      WidgetsFlutterBinding.ensureInitialized();
      context.read<UserProfileBloc>().add(const FetchNotificationsEnabled());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((UserProfileBloc bloc) => bloc.state.user);
    final notificationsEnabled = context
        .select((UserProfileBloc bloc) => bloc.state.notificationsEnabled);
    final isUserSubscribed = context.select<AppBloc, bool>(
      (bloc) => bloc.state.isUserSubscribed,
    );

    final l10n = context.l10n;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state.status == UserProfileStatus.togglingNotificationsSucceeded &&
            state.notificationsEnabled) {
          context
              .read<AnalyticsBloc>()
              .add(TrackAnalyticsEvent(PushNotificationSubscriptionEvent()));
        }
      },
      child: BlocListener<AppBloc, AppState>(
        listener: (context, state) {
          if (state.status == AppStatus.unauthenticated) {
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const UserProfileTitle(),
                    if (!user.isAnonymous) ...[
                      UserProfileItem(
                        key: const Key('userProfilePage_userItem'),
                        leading: Assets.icons.profileIcon.svg(),
                        title: user.email ?? '',
                      ),
                      const UserProfileLogoutButton(),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    const _UserProfileDivider(),
                    UserProfileSubtitle(
                      subtitle: l10n.userProfileSubscriptionDetailsSubtitle,
                    ),
                    if (isUserSubscribed)
                      UserProfileItem(
                        key: const Key('userProfilePage_subscriptionItem'),
                        title: l10n.manageSubscriptionTile,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.goNamed(
                          ManageSubscriptionPage.routePath,
                        ),
                      )
                    else
                      UserProfileSubscribeBox(
                        onSubscribePressed: () =>
                            showPurchaseSubscriptionDialog(context: context),
                      ),
                    const _UserProfileDivider(),
                    UserProfileSubtitle(
                      subtitle: l10n.userProfileSettingsSubtitle,
                    ),
                    UserProfileItem(
                      key: const Key('userProfilePage_notificationsItem'),
                      leading: Assets.icons.notificationsIcon.svg(),
                      title: l10n.userProfileSettingsNotificationsTitle,
                      trailing: AppSwitch(
                        onText: l10n.checkboxOnTitle,
                        offText: l10n.userProfileCheckboxOffTitle,
                        value: notificationsEnabled,
                        onChanged: (_) => context
                            .read<UserProfileBloc>()
                            .add(const ToggleNotifications()),
                      ),
                    ),
                    UserProfileItem(
                      key: const Key(
                        'userProfilePage_notificationPreferencesItem',
                      ),
                      title: l10n.notificationPreferencesTitle,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.goNamed(
                        NotificationPreferencesPage.routePath,
                      ),
                    ),
                    const _UserProfileDivider(),
                    UserProfileSubtitle(
                      subtitle: l10n.userProfileLegalSubtitle,
                    ),
                    UserProfileItem(
                      key: const Key('userProfilePage_termsOfServiceItem'),
                      leading: Assets.icons.termsOfUseIcon.svg(),
                      title:
                          l10n.userProfileLegalTermsOfUseAndPrivacyPolicyTitle,
                      onTap: () => Navigator.of(context)
                          .push<void>(TermsOfServicePage.route()),
                    ),
                    UserProfileItem(
                      key: const Key('userProfilePage_aboutItem'),
                      leading: Assets.icons.aboutIcon.svg(),
                      title: l10n.userProfileLegalAboutTitle,
                    ),
                    Align(
                      child: AppButton.smallTransparent(
                        key: const Key('userProfilePage_deleteAccountButton'),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (_) =>
                                const UserProfileDeleteAccountDialog(),
                          );
                        },
                        child: Text(
                          l10n.userProfileDeleteAccountButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        context.l10n.userProfileTitle,
        style: theme.textTheme.displaySmall,
      ),
    );
  }
}

@visibleForTesting
class UserProfileSubtitle extends StatelessWidget {
  const UserProfileSubtitle({required this.subtitle, super.key});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        subtitle,
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}

@visibleForTesting
class UserProfileItem extends StatelessWidget {
  const UserProfileItem({
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  static const _leadingWidth = AppSpacing.xxxlg + AppSpacing.sm;

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;

    return ListTile(
      dense: true,
      leading: SizedBox(
        width: hasLeading ? _leadingWidth : 0,
        child: leading,
      ),
      trailing: trailing,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        hasLeading ? 0 : AppSpacing.xlg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      horizontalTitleGap: 0,
      minLeadingWidth: hasLeading ? _leadingWidth : 0,
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.highEmphasisSurface,
            ),
      ),
    );
  }
}

@visibleForTesting
class UserProfileLogoutButton extends StatelessWidget {
  const UserProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxlg + AppSpacing.lg,
      ),
      child: AppButton.smallDarkAqua(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.logOutIcon.svg(),
            const SizedBox(width: AppSpacing.sm),
            Text(context.l10n.userProfileLogoutButtonText),
          ],
        ),
        onPressed: () =>
            context.read<AppBloc>().add(const AppLogoutRequested()),
      ),
    );
  }
}

class _UserProfileDivider extends StatelessWidget {
  const _UserProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Divider(
        color: AppColors.borderOutline,
        indent: 0,
        endIndent: 0,
      ),
    );
  }
}
