// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    test('has a page', () {
      expect(HomePage.page(), isA<MaterialPage>());
    });

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(HomePage());
      expect(find.byType(HomeView), findsOneWidget);
    });

    group('HomeView', () {
      testWidgets('renders AppBar with AppLogo', (tester) async {
        await tester.pumpApp(HomePage());
        expect(
          find.byWidgetPredicate(
            (widget) => widget is AppBar && widget.title is AppLogo,
          ),
          findsOneWidget,
        );
      });

      testWidgets('renders UserProfileButton', (tester) async {
        await tester.pumpApp(HomePage());
        expect(find.byType(UserProfileButton), findsOneWidget);
      });

      testWidgets(
          'renders NavigationDrawer '
          'when menu icon is tapped', (tester) async {
        await tester.pumpApp(HomePage());

        expect(find.byType(NavigationDrawer), findsNothing);

        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();

        expect(find.byType(NavigationDrawer), findsOneWidget);
      });
    });
  });
}
