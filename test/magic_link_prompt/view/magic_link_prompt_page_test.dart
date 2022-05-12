// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/magic_link_prompt/magic_link_prompt.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const testEmail = 'testEmail@gmail.com';
  const magicLinkPromptCloseIconKey = Key('magicLinkPrompt_closeIcon');

  group('MagicLinkPromptPage', () {
    test('has a route', () {
      expect(
        MagicLinkPromptPage.route(email: testEmail),
        isA<MaterialPageRoute>(),
      );
    });

    testWidgets('renders a MagicLinkPromptView', (tester) async {
      await tester.pumpApp(
        const MagicLinkPromptPage(email: testEmail),
      );
      expect(find.byType(MagicLinkPromptView), findsOneWidget);
    });

    testWidgets('router returns a valid navigation route', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(MagicLinkPromptPage.route(email: testEmail));
                },
                child: const Text('Tap me'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(find.byType(MagicLinkPromptPage), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when pressed on close icon', (tester) async {
        final navigator = MockNavigator();

        when(() => navigator.popUntil(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          const MagicLinkPromptPage(email: testEmail),
          navigator: navigator,
        );

        await tester.tap(find.byKey(magicLinkPromptCloseIconKey));
        await tester.pumpAndSettle();
        verify(() => navigator.popUntil(any())).called(1);
      });
    });
  });
}
