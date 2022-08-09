import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/notification_preferences/notification_preferences.dart';

import '../../helpers/helpers.dart';

void main() {
  group('NotificationCategoryTile', () {
    testWidgets('renders trailing', (tester) async {
      await tester.pumpApp(
        const NotificationCategoryTile(
          title: 'title',
          trailing: Icon(Icons.image),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('calls onTap on ListTile click', (tester) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        NotificationCategoryTile(
          title: 'title',
          trailing: const Icon(Icons.image),
          onTap: completer.complete,
        ),
      );

      await tester.tap(find.byType(ListTile));

      expect(completer.isCompleted, isTrue);
    });
  });
}
