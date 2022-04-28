import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/theme_selector/theme_selector.dart';
import 'package:mockingjay/mockingjay.dart'
    show MockNavigatorProvider, MockNavigator;
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {
  @override
  AppState get state => const AppState.unauthenticated();
}

class MockThemeModeBloc extends MockBloc<ThemeModeEvent, ThemeMode>
    implements ThemeModeBloc {
  @override
  ThemeMode get state => ThemeMode.system;
}

class MockUserRepository extends Mock implements UserRepository {
  @override
  Stream<Uri> get incomingEmailLinks => const Stream.empty();
}

extension AppTester on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    AppBloc? appBloc,
    UserRepository? userRepository,
    TargetPlatform? platform,
    ThemeModeBloc? themeModeBloc,
    NavigatorObserver? navigatorObserver,
    MockNavigator? navigator,
  }) async {
    await pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc ?? MockAppBloc()),
            BlocProvider.value(value: themeModeBloc ?? MockThemeModeBloc()),
          ],
          child: MaterialApp(
            title: 'Google News Template',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Theme(
              data: ThemeData(platform: platform),
              child: navigator == null
                  ? Scaffold(body: widgetUnderTest)
                  : MockNavigatorProvider(
                      navigator: navigator,
                      child: Scaffold(body: widgetUnderTest),
                    ),
            ),
            navigatorObservers: [
              if (navigatorObserver != null) navigatorObserver
            ],
          ),
        ),
      ),
    );
    await pump();
  }
}
