import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_news_template/main/bootstrap/app_bloc_observer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

Future<void> bootstrap(Future<Widget> Function() builder) async {
  return HydratedBlocOverrides.runZoned(
    () => _runApp(builder),
    createStorage: _createStorage,
  );
}

Future<void> _runApp(Future<Widget> Function() builder) async {
  await Firebase.initializeApp();
  final blocObserver = AppBlocObserver(
    analyticsRepository: AnalyticsRepository(FirebaseAnalytics()),
  );
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await runZonedGuarded<Future<void>>(
    () => BlocOverrides.runZoned(
      () async {
        unawaited(MobileAds.instance.initialize());
        runApp(await builder());
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
