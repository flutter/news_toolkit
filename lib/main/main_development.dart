import 'dart:async';

import 'package:deep_link_client/deep_link_client.dart';
import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/main/bootstrap/bootstrap.dart';
import 'package:google_news_template/src/version.dart';
import 'package:google_news_template_api/client.dart';
import 'package:news_repository/news_repository.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    () async {
      final firebaseDynamicLinks = FirebaseDynamicLinks.instance;

      unawaited(MobileAds.instance.initialize());

      final packageInfoClient = PackageInfoClient(
        appName: 'Google News Template [DEV]',
        packageName: 'com.google.news.template.dev',
        packageVersion: packageVersion,
      );

      final deepLinkClient = DeepLinkClient(
        firebaseDynamicLinks: firebaseDynamicLinks,
      );

      final userRepository = UserRepository(
        authenticationClient: FirebaseAuthenticationClient(),
        packageInfoClient: packageInfoClient,
        deepLinkClient: deepLinkClient,
      );

      final newsRepository = NewsRepository(
        apiClient: GoogleNewsTemplateApiClient(),
      );

      return App(
        userRepository: userRepository,
        newsRepository: newsRepository,
        user: await userRepository.user.first,
      );
    },
  );
}
