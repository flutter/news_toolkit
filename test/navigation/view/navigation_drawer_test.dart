// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/navigation/navigation.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NavigationDrawer', () {
    testWidgets('renders Drawer', (tester) async {
      await tester.pumpApp(NavigationDrawer());
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('renders AppLogo', (tester) async {
      await tester.pumpApp(NavigationDrawer());
      expect(find.byType(AppLogo), findsOneWidget);
    });
  });
}
