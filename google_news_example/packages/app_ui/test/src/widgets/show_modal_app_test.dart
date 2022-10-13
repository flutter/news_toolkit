// ignore_for_file: prefer_const_constructors

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('ShowAppModal', () {
    testWidgets('renders modal', (tester) async {
      final modalKey = Key('appModal_container');
      await tester.pumpApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showAppModal<void>(
              context: context,
              builder: (context) => Container(
                key: modalKey,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: const Text('Tap'),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byKey(modalKey), findsOneWidget);
    });
  });
}
