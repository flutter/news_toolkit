import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/main/bootstrap/bootstrap.dart';
import 'package:google_news_template/src/version.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  bootstrap(
    () async {
      final packageInfoClient = PackageInfoClient(
        appName: 'Google News Template [DEV]',
        packageName: 'com.google.news.template.dev',
        packageVersion: packageVersion,
      );

      final userRepository = UserRepository(
        authenticationClient: FirebaseAuthenticationClient(),
        packageInfoClient: packageInfoClient,
      );

      return App(
        userRepository: userRepository,
        user: await userRepository.user.first,
      );
    },
  );
}
