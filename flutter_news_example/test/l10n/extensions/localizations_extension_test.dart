import 'package:flutter/material.dart';
import 'package:flutter_news_example/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LocalizationsX', () {
    testWidgets('performs localizations lookup', (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => Text(context.l10n.loginButtonText),
        ),
      );
      expect(find.text('LOGIN'), findsOneWidget);
    });
  });
}
