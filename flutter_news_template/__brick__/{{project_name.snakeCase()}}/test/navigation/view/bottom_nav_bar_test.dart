// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/navigation/navigation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BottomNavBar', () {
    testWidgets(
      'renders with currentIndex to 0 by default.',
      (tester) async {
        await tester.pumpApp(
          BottomNavBar(
            currentIndex: 0,
            onTap: (selectedIndex) {},
          ),
        );
        expect(find.byType(BottomNavBar), findsOneWidget);
      },
    );
  });

  testWidgets('calls onTap when navigation bar item is tapped', (tester) async {
    final completer = Completer<void>();

    await tester.pumpApp(
      Scaffold(
        body: Container(),
        bottomNavigationBar: BottomNavBar(
          currentIndex: 0,
          onTap: (value) => completer.complete(),
        ),
      ),
    );
    await tester.ensureVisible(find.byType(BottomNavigationBar));
    await tester.tap(find.byIcon(Icons.home_outlined));
    expect(completer.isCompleted, isTrue);
  });

  testWidgets(
    'renders BottomNavigationBar with currentIndex',
    (tester) async {
      const currentIndex = 1;
      await tester.pumpApp(
        BottomNavBar(
          currentIndex: currentIndex,
          onTap: (selectedIndex) {},
        ),
      );
      final bottomNavBar = tester.widget<BottomNavBar>(
        find.byType(BottomNavBar),
      );
      expect(bottomNavBar.currentIndex, equals(currentIndex));
    },
  );
}
