import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_news_template/main/bootstrap/app_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef AppBuilder = Future<Widget> Function(
  FirebaseDynamicLinks firebaseDynamicLinks,
  FirebaseMessaging firebaseMessaging,
  SharedPreferences sharedPreferences,
  AnalyticsRepository analyticsRepository,
);

Future<void> bootstrap(AppBuilder builder) async {
  return HydratedBlocOverrides.runZoned(
    () => _runApp(builder),
    createStorage: _createStorage,
  );
}

Future<void> _runApp(AppBuilder builder) async {
  await Firebase.initializeApp();
  // ignore: prefer_const_constructors
  final analyticsRepository = AnalyticsRepository(FirebaseAnalytics.instance);
  final blocObserver = AppBlocObserver(
    analyticsRepository: analyticsRepository,
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  final sharedPreferences = await SharedPreferences.getInstance();

  await runZonedGuarded<Future<void>>(
    () => BlocOverrides.runZoned(
      () async {
        unawaited(MobileAds.instance.initialize());
        runApp(
          await builder(
            FirebaseDynamicLinks.instance,
            FirebaseMessaging.instance,
            sharedPreferences,
            analyticsRepository,
          ),
        );
      },
      blocObserver: blocObserver,
    ),
    FirebaseCrashlytics.instance.recordError,
  );
}

Future<Storage> _createStorage() async {
  WidgetsFlutterBinding.ensureInitialized();
  return HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );
}
