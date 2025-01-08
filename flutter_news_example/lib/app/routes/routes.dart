import 'package:flutter_news_example/article/article.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/magic_link_prompt/view/magic_link_prompt_page.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_news_example/notification_preferences/notification_preferences.dart';
import 'package:flutter_news_example/onboarding/onboarding.dart';
import 'package:flutter_news_example/slideshow/slideshow.dart';
import 'package:flutter_news_example/subscriptions/view/manage_subscription_page.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: HomePage.routePath,
      builder: HomePage.routeBuilder,
      routes: <RouteBase>[
        GoRoute(
          name: NetworkErrorPage.routePath,
          path: NetworkErrorPage.routePath,
          builder: NetworkErrorPage.routeBuilder,
        ),
        GoRoute(
          name: LoginWithEmailPage.routePath,
          path: LoginWithEmailPage.routePath,
          builder: LoginWithEmailPage.routeBuilder,
          routes: <RouteBase>[
            GoRoute(
              name: MagicLinkPromptPage.routePath,
              path: MagicLinkPromptPage.routePath,
              builder: MagicLinkPromptPage.routeBuilder,
            ),
          ],
        ),
        GoRoute(
          name: ArticlePage.routeName,
          path: ArticlePage.routePath,
          builder: ArticlePage.routeBuilder,
          routes: <RouteBase>[
            GoRoute(
              name: SlideshowPage.routePath,
              path: SlideshowPage.routePath,
              builder: SlideshowPage.routeBuilder,
            ),
          ],
        ),
        GoRoute(
          name: UserProfilePage.routePath,
          path: UserProfilePage.routePath,
          builder: UserProfilePage.routeBuilder,
          routes: <RouteBase>[
            GoRoute(
              name: ManageSubscriptionPage.routePath,
              path: ManageSubscriptionPage.routePath,
              builder: ManageSubscriptionPage.routeBuilder,
            ),
            GoRoute(
              name: NotificationPreferencesPage.routePath,
              path: NotificationPreferencesPage.routePath,
              builder: NotificationPreferencesPage.routeBuilder,
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: OnboardingPage.routePath,
      path: OnboardingPage.routePath,
      builder: OnboardingPage.routeBuilder,
    ),
  ],
);
