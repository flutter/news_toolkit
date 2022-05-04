// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/navigation/navigation.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NavigationDrawerSubscribe', () {
    testWidgets('renders NavigationDrawerSubscribeTitle', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeTitle), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSubscribeSubtitle', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeSubtitle), findsOneWidget);
    });

    testWidgets('renders NavigationDrawerSubscribeButton', (tester) async {
      await tester.pumpApp(NavigationDrawerSubscribe());
      expect(find.byType(NavigationDrawerSubscribeButton), findsOneWidget);
    });

    group('NavigationDrawerSubscribeButton', () {
      testWidgets('renders AppButton', (tester) async {
        await tester.pumpApp(NavigationDrawerSubscribeButton());
        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('does nothing when tapped', (tester) async {
        await tester.pumpApp(NavigationDrawerSubscribeButton());
        await tester.tap(find.byType(NavigationDrawerSubscribeButton));
      });
    });
  });
}
