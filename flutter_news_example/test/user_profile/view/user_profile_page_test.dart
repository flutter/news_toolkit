// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/analytics/analytics.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:flutter_news_example/subscriptions/subscriptions.dart';
import 'package:flutter_news_example/terms_of_service/terms_of_service.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:user_repository/user_repository.dart';

import '../../helpers/helpers.dart';

class MockUserProfileBloc extends MockBloc<UserProfileEvent, UserProfileState>
    implements UserProfileBloc {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockGoRouter extends Mock implements GoRouter {}

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  const termsOfServiceItemKey = Key('userProfilePage_termsOfServiceItem');
  late GoRouter goRouter;
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
  });

  group('UserProfilePage', () {
    testWidgets('routeBuilder builds a UserProfilePage', (tester) async {
      final page = UserProfilePage.routeBuilder(context, goRouterState);

      expect(page, isA<UserProfilePage>());
    });

    testWidgets('renders UserProfileView', (tester) async {
      await tester.pumpApp(UserProfilePage());
      expect(find.byType(UserProfileView), findsOneWidget);
    });

    group('UserProfileView', () {
      late InAppPurchaseRepository inAppPurchaseRepository;
      late UserProfileBloc userProfileBloc;
      late AnalyticsBloc analyticsBloc;
      late AppBloc appBloc;

      final user = User(
        id: '1',
        email: 'email',
        subscriptionPlan: SubscriptionPlan.none,
      );
      const notificationsEnabled = true;

      setUp(() {
        inAppPurchaseRepository = MockInAppPurchaseRepository();
        userProfileBloc = MockUserProfileBloc();
        analyticsBloc = MockAnalyticsBloc();
        appBloc = MockAppBloc();

        final initialState = UserProfileState.initial().copyWith(
          user: user,
          notificationsEnabled: notificationsEnabled,
        );

        whenListen(
          userProfileBloc,
          Stream.value(initialState),
          initialState: initialState,
        );

        whenListen(
          appBloc,
          Stream.fromIterable(
            <AppState>[AppState.unauthenticated()],
          ),
          initialState: AppState.authenticated(user),
        );
      });

      testWidgets(
          'adds FetchNotificationsEnabled to UserProfileBloc '
          'when initialized and each time the app is resumed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        verify(
          () => userProfileBloc.add(FetchNotificationsEnabled()),
        ).called(1);

        tester.binding
            .handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        verify(
          () => userProfileBloc.add(FetchNotificationsEnabled()),
        ).called(1);

        tester.binding
          ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
          ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);

        verify(
          () => userProfileBloc.add(FetchNotificationsEnabled()),
        ).called(1);
      });

      testWidgets(
          'navigates back '
          'when app back button is pressed', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        await tester.tap(find.byType(AppBackButton));
        await tester.pumpAndSettle();

        expect(find.byType(UserProfileView), findsNothing);
      });

      testWidgets(
          'navigates back '
          'when user is unauthenticated', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
          appBloc: appBloc,
        );

        await tester.pumpAndSettle();

        expect(find.byType(UserProfileView), findsNothing);
      });

      testWidgets(
          'adds TrackAnalyticsEvent to AnalyticsBloc '
          'with PushNotificationSubscriptionEvent '
          'when status is togglingNotificationsSucceeded '
          'and notificationsEnabled is true', (tester) async {
        whenListen(
          userProfileBloc,
          Stream.fromIterable([
            UserProfileState.initial(),
            UserProfileState(
              user: User.anonymous,
              notificationsEnabled: true,
              status: UserProfileStatus.togglingNotificationsSucceeded,
            ),
          ]),
        );

        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: userProfileBloc),
              BlocProvider.value(value: analyticsBloc),
            ],
            child: UserProfileView(),
          ),
        );

        verify(
          () => analyticsBloc.add(
            TrackAnalyticsEvent(PushNotificationSubscriptionEvent()),
          ),
        ).called(1);
      });

      testWidgets('renders UserProfileTitle', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        expect(
          find.byType(UserProfileTitle),
          findsOneWidget,
        );
      });

      testWidgets('renders user email', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) => widget is UserProfileItem && widget.title == user.email,
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'renders notifications item '
          'with trailing AppSwitch', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key == Key('userProfilePage_notificationsItem') &&
                widget.trailing is AppSwitch,
          ),
          findsOneWidget,
        );

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppSwitch && widget.value == notificationsEnabled,
          ),
          findsOneWidget,
        );
      });

      group(
          'renders UserProfileSubscribeBox '
          'when isUserSubscribed is false', () {
        testWidgets('correctly', (tester) async {
          whenListen(
            appBloc,
            Stream.fromIterable([
              AppState.authenticated(user),
            ]),
          );

          await tester.pumpApp(
            appBloc: appBloc,
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
          );

          expect(find.byType(UserProfileSubscribeBox), findsOneWidget);
        });

        testWidgets('opens PurchaseSubscriptionDialog when tapped',
            (tester) async {
          whenListen(
            appBloc,
            Stream.fromIterable([
              AppState.authenticated(user),
            ]),
          );

          when(() => inAppPurchaseRepository.purchaseUpdate).thenAnswer(
            (_) => const Stream.empty(),
          );

          when(inAppPurchaseRepository.fetchSubscriptions).thenAnswer(
            (invocation) async => [],
          );

          await tester.pumpApp(
            inAppPurchaseRepository: inAppPurchaseRepository,
            appBloc: appBloc,
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
          );
          final subscriptionButton =
              find.byKey(Key('userProfileSubscribeBox_appButton'));
          await tester.scrollUntilVisible(subscriptionButton, -50);
          await tester.tap(subscriptionButton);
          await tester.pump();

          expect(
            find.byType(PurchaseSubscriptionDialog),
            findsOneWidget,
          );
        });
      });

      testWidgets(
          'renders notification preferences item '
          'with trailing Icon', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key ==
                    Key('userProfilePage_notificationPreferencesItem') &&
                widget.trailing is Icon,
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders terms of use and privacy policy item',
          (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key == Key('userProfilePage_termsOfServiceItem'),
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders about item', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is UserProfileItem &&
                widget.key == Key('userProfilePage_aboutItem'),
          ),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds ToggleNotifications to UserProfileBloc '
          'when notifications item trailing is tapped', (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: userProfileBloc,
            child: UserProfileView(),
          ),
        );
        await tester.tap(find.byType(AppSwitch));
        verify(() => userProfileBloc.add(ToggleNotifications())).called(1);
      });

      group('UserProfileItem', () {
        testWidgets('renders ListTile', (tester) async {
          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
            ),
          );

          expect(find.widgetWithText(ListTile, 'title'), findsOneWidget);
        });

        testWidgets('renders leading', (tester) async {
          const leadingKey = Key('__leading__');

          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              leading: SizedBox(key: leadingKey),
            ),
          );

          expect(find.byKey(leadingKey), findsOneWidget);
        });

        testWidgets('renders trailing', (tester) async {
          const trailingKey = Key('__trailing__');

          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              trailing: SizedBox(key: trailingKey),
            ),
          );

          expect(find.byKey(trailingKey), findsOneWidget);
        });

        testWidgets('calls onTap when tapped', (tester) async {
          var tapped = false;
          await tester.pumpApp(
            UserProfileItem(
              title: 'title',
              onTap: () => tapped = true,
            ),
          );

          await tester.tap(find.byType(UserProfileItem));

          expect(tapped, isTrue);
        });
      });

      group('UserProfileLogoutButton', () {
        testWidgets('renders AppButton', (tester) async {
          await tester.pumpApp(UserProfileLogoutButton());
          expect(find.byType(AppButton), findsOneWidget);
        });

        testWidgets(
            'adds AppLogoutRequested to AppBloc '
            'when tapped', (tester) async {
          await tester.pumpApp(
            UserProfileLogoutButton(),
            appBloc: appBloc,
          );

          await tester.tap(find.byType(UserProfileLogoutButton));

          verify(() => appBloc.add(AppLogoutRequested())).called(1);
        });
      });

      group('navigates', () {
        setUp(() {
          goRouter = MockGoRouter();
        });
        testWidgets('when tapped on Terms of User & Privacy Policy',
            (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
          );

          final termsOfService = find.byKey(termsOfServiceItemKey);

          await tester.dragUntilVisible(
            termsOfService,
            find.byType(UserProfileView),
            Offset(0, -100),
            duration: Duration.zero,
          );
          await tester.pumpAndSettle();
          await tester.ensureVisible(termsOfService);
          await tester.tap(termsOfService);
          await tester.pumpAndSettle();

          expect(find.byType(TermsOfServicePage), findsOneWidget);
        });

        testWidgets(
            'to ManageSubscriptionPage '
            'when isUserSubscribed is true and '
            'tapped on Manage Subscription', (tester) async {
          when(() => goRouter.goNamed(ManageSubscriptionPage.routePath))
              .thenAnswer((_) {});

          final subscribedUser = User(
            id: '1',
            email: 'email',
            subscriptionPlan: SubscriptionPlan.premium,
          );
          whenListen(
            appBloc,
            Stream.fromIterable([AppState.authenticated(subscribedUser)]),
          );

          await tester.pumpApp(
            appBloc: appBloc,
            InheritedGoRouter(
              goRouter: goRouter,
              child: BlocProvider.value(
                value: userProfileBloc,
                child: UserProfileView(),
              ),
            ),
          );

          final subscriptionItem =
              find.byKey(Key('userProfilePage_subscriptionItem'));
          await tester.ensureVisible(subscriptionItem);
          await tester.tap(subscriptionItem);

          verify(() => goRouter.goNamed(ManageSubscriptionPage.routePath))
              .called(1);
        });

        testWidgets(
            'to NotificationPreferencesPage '
            'when tapped on NotificationPreferences', (tester) async {
          when(() => goRouter.goNamed(NotificationPreferencesPage.routePath))
              .thenAnswer((_) {});
          await tester.pumpApp(
            InheritedGoRouter(
              goRouter: goRouter,
              child: BlocProvider.value(
                value: userProfileBloc,
                child: UserProfileView(),
              ),
            ),
          );

          final subscriptionItem = find.byKey(
            Key('userProfilePage_notificationPreferencesItem'),
          );
          await tester.dragUntilVisible(
            subscriptionItem,
            find.byType(UserProfileView),
            Offset(0, -100),
            duration: Duration.zero,
          );
          await tester.pumpAndSettle();

          await tester.ensureVisible(subscriptionItem);
          await tester.tap(subscriptionItem);

          verify(() => goRouter.goNamed(NotificationPreferencesPage.routePath))
              .called(1);
        });
      });

      group('shows', () {
        testWidgets(
            'UserProfileDeleteAccountDialog '
            'when tapped on Delete account', (tester) async {
          await tester.pumpApp(
            BlocProvider.value(
              value: userProfileBloc,
              child: UserProfileView(),
            ),
          );

          final deleteAccountButton = find.byKey(
            Key('userProfilePage_deleteAccountButton'),
          );
          await tester.dragUntilVisible(
            deleteAccountButton,
            find.byType(UserProfileView),
            Offset(0, -100),
            duration: Duration.zero,
          );
          await tester.pumpAndSettle();

          await tester.ensureVisible(deleteAccountButton);
          await tester.tap(deleteAccountButton);
          await tester.pumpAndSettle();

          expect(find.byType(UserProfileDeleteAccountDialog), findsOneWidget);
        });
      });
    });
  });
}
