import 'package:flutter/widgets.dart';
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
import 'package:news_blocks/news_blocks.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: HomePage.routePath,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          name: NetworkErrorPage.routePath,
          path: NetworkErrorPage.routePath,
          builder: (BuildContext context, GoRouterState state) {
            final onRetry = state.extra as VoidCallback?;
            return NetworkError(onRetry: onRetry);
          },
        ),
        GoRoute(
          name: LoginWithEmailPage.routePath,
          path: LoginWithEmailPage.routePath,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginWithEmailPage();
          },
          routes: <RouteBase>[
            GoRoute(
              name: MagicLinkPromptPage.routePath,
              path: MagicLinkPromptPage.routePath,
              builder: (BuildContext context, GoRouterState state) {
                return MagicLinkPromptPage(
                  email: state.uri.queryParameters['email']!,
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: ArticlePage.routeName,
          path: ArticlePage.routePath,
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id'];

            final isVideoArticle = bool.tryParse(
                  state.uri.queryParameters['isVideoArticle'] ?? 'false',
                ) ??
                false;
            final interstitialAdBehavior =
                state.uri.queryParameters['interstitialAdBehavior'] != null
                    ? InterstitialAdBehavior.values.firstWhere(
                        (e) =>
                            e.toString() ==
                            'InterstitialAdBehavior.'
                                '${state.uri.queryParameters['interstitialAdBehavior']}',
                      )
                    : null;

            if (id == null) {
              throw Exception('Missing required "id" parameter');
            }

            return ArticlePage(
              id: id,
              isVideoArticle: isVideoArticle,
              interstitialAdBehavior:
                  interstitialAdBehavior ?? InterstitialAdBehavior.onOpen,
            );
          },
          routes: <RouteBase>[
            GoRoute(
              name: SlideshowPage.routePath,
              path: SlideshowPage.routePath,
              builder: (BuildContext context, GoRouterState state) {
                return SlideshowPage(
                  slideshow: state.extra! as SlideshowBlock,
                  articleId: state.pathParameters['id']!,
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: UserProfilePage.routePath,
          path: UserProfilePage.routePath,
          builder: (BuildContext context, GoRouterState state) {
            return const UserProfilePage();
          },
          routes: <RouteBase>[
            GoRoute(
              name: ManageSubscriptionPage.routePath,
              path: ManageSubscriptionPage.routePath,
              builder: (BuildContext context, GoRouterState state) {
                return const ManageSubscriptionPage();
              },
            ),
            GoRoute(
              name: NotificationPreferencesPage.routePath,
              path: NotificationPreferencesPage.routePath,
              builder: (BuildContext context, GoRouterState state) {
                return const NotificationPreferencesPage();
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: OnboardingPage.routePath,
      path: OnboardingPage.routePath,
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingPage();
      },
    ),
  ],
);
