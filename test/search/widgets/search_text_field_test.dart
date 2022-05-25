import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SearchTextField', () {
    testWidgets('calls onChanged when text input changes', (tester) async {
      final controller = TextEditingController();
      final completer = Completer<void>();

      await tester.pumpApp(
        SearchTextField(
          controller: controller,
          onChanged: completer.complete,
        ),
      );

      await tester.enterText(find.byType(AppTextField), 'text');

      expect(completer.isCompleted, isTrue);
    });

    testWidgets('clears controller on IconButton pressed', (tester) async {
      final controller = TextEditingController(text: 'text');
      final completer = Completer<void>();

      await tester.pumpApp(
        SearchTextField(
          controller: controller,
          onChanged: completer.complete,
        ),
      );
      await tester.tap(find.byType(IconButton));

      expect(controller.value.text, equals(''));
    });
  });
}
