// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/user_profile/user_profile.dart';

import '../../helpers/helpers.dart';

void main() {
  group('UserProfileSwitch', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    testWidgets(
        'renders `On` text '
        'when enabled', (tester) async {
      await tester.pumpApp(
        UserProfileSwitch(
          value: true,
          onChanged: (_) {},
        ),
      );

      expect(find.text(l10n.userProfileCheckboxOnTitle), findsOneWidget);
    });

    testWidgets(
        'renders `Off` text '
        'when disabled', (tester) async {
      await tester.pumpApp(
        UserProfileSwitch(
          value: false,
          onChanged: (_) {},
        ),
      );

      expect(find.text(l10n.userProfileCheckboxOffTitle), findsOneWidget);
    });

    testWidgets('renders Switch', (tester) async {
      await tester.pumpApp(
        UserProfileSwitch(
          value: true,
          onChanged: (_) {},
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is Switch && widget.value == true,
        ),
        findsOneWidget,
      );
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        UserProfileSwitch(
          value: true,
          onChanged: (_) => tapped = true,
        ),
      );

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
