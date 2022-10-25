import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/search.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SearchTextField', () {
    testWidgets('changes controller.value when text input changes',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpApp(
        SearchTextField(
          controller: controller,
        ),
      );

      await tester.enterText(find.byType(AppTextField), 'text');

      expect(controller.value.text, equals('text'));
    });

    testWidgets('clears controller on IconButton pressed', (tester) async {
      final controller = TextEditingController(text: 'text');

      await tester.pumpApp(
        SearchTextField(
          controller: controller,
        ),
      );
      await tester.tap(find.byType(IconButton));

      expect(controller.value.text, equals(''));
    });
  });
}
