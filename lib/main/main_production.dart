import 'package:article_repository/article_repository.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/main/bootstrap/bootstrap.dart';
import 'package:google_news_template/src/version.dart';
import 'package:google_news_template_api/client.dart';
import 'package:in_app_purchase_repository/in_app_purchase_repository.dart';
import 'package:news_repository/news_repository.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:permission_client/permission_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
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

      final apiClient = GoogleNewsTemplateApiClient(
        tokenProvider: tokenStorage.readToken,
      );

      const permissionClient = PermissionClient();

      final persistentStorage = PersistentStorage(
        sharedPreferences: sharedPreferences,
      );

      final packageInfoClient = PackageInfoClient(
        appName: 'Google News Template',
        packageName: 'com.google.news.template',
        packageVersion: packageVersion,
      );

      final deepLinkClient = DeepLinkClient(
        firebaseDynamicLinks: firebaseDynamicLinks,
      );

      final userStorage = UserStorage(storage: persistentStorage);

      final userRepository = UserRepository(
        authenticationClient: FirebaseAuthenticationClient(
          tokenStorage: tokenStorage,
        ),
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
        firebaseMessaging: firebaseMessaging,
        apiClient: apiClient,
      );

      final articleRepository = ArticleRepository(
        storage: ArticleStorage(storage: persistentStorage),
        apiClient: apiClient,
      );

      final inAppPurchaseRepository = InAppPurchaseRepository(
        apiClient: apiClient,
      );

      return App(
        userRepository: userRepository,
        newsRepository: newsRepository,
        notificationsRepository: notificationsRepository,
        articleRepository: articleRepository,
        inAppPurchaseRepository: inAppPurchaseRepository,
        analyticsRepository: analyticsRepository,
        user: await userRepository.user.first,
      );
    },
  );
}
