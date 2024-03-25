import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:article_repository/article_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_deep_link_service/firebase_deep_link_service.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/main/bootstrap/bootstrap.dart';
import 'package:flutter_news_example/src/version.dart';
import 'package:flutter_news_example_api/client.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:purchase_client/purchase_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    (
      firebaseDynamicLinks,
      firebaseMessaging,
      sharedPreferences,
      analyticsRepository,
    ) async {
      final tokenStorage = InMemoryTokenStorage();

      final apiClient = FlutterNewsExampleApiClient.localhost(
        tokenProvider: tokenStorage.readToken,
      );

      const permissionClient = PermissionClient();

      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

      final packageInfoClient = PackageInfoClient(
        appName: 'Flutter News Example [DEV]',
        packageName: 'com.flutter.news.example.dev',
        packageVersion: packageVersion,
      );

      final deepLinkClient = DeepLinkClient(
        deepLinkService: FirebaseDeepLinkService(
          firebaseDynamicLinks: firebaseDynamicLinks,
        ),
      );

      final userStorage = UserStorage(storage: persistentStorage);

      final authenticationClient = FirebaseAuthenticationClient(
        tokenStorage: tokenStorage,
      );

      final notificationsClient = FirebaseNotificationsClient(
        firebaseMessaging: firebaseMessaging,
      );

      final userRepository = UserRepository(
        apiClient: apiClient,
        authenticationClient: authenticationClient,
        packageInfoClient: packageInfoClient,
        deepLinkClient: deepLinkClient,
        storage: userStorage,
      );

      final newsRepository = NewsRepository(
        apiClient: apiClient,
      );

      final notificationsRepository = NotificationsRepository(
        permissionClient: permissionClient,
        storage: NotificationsStorage(storage: persistentStorage),
        notificationsClient: notificationsClient,
        apiClient: apiClient,
      );

      final articleRepository = ArticleRepository(
        storage: ArticleStorage(storage: persistentStorage),
        apiClient: apiClient,
      );

      final inAppPurchaseRepository = InAppPurchaseRepository(
        authenticationClient: authenticationClient,
        apiClient: apiClient,
        inAppPurchase: PurchaseClient(),
      );

      final adsConsentClient = AdsConsentClient();

      return App(
        userRepository: userRepository,
        newsRepository: newsRepository,
        notificationsRepository: notificationsRepository,
        articleRepository: articleRepository,
        analyticsRepository: analyticsRepository,
        inAppPurchaseRepository: inAppPurchaseRepository,
        adsConsentClient: adsConsentClient,
        user: await userRepository.user.first,
      );
    },
  );
}
