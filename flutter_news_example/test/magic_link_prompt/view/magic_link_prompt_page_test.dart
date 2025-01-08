// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_news_example/magic_link_prompt/magic_link_prompt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  const testEmail = 'testEmail@gmail.com';
  const magicLinkPromptCloseIconKey = Key('magicLinkPrompt_closeIcon');
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
  });

  group('MagicLinkPromptPage', () {
    testWidgets('routeBuilder builds a MagicLinkPromptPage', (tester) async {
      when(() => goRouterState.uri)
          .thenReturn(Uri(queryParameters: {'email': 'email'}));

      final page = MagicLinkPromptPage.routeBuilder(context, goRouterState);

      expect(page, isA<MagicLinkPromptPage>());
    });

    testWidgets('renders a MagicLinkPromptView', (tester) async {
      await tester.pumpApp(
        const MagicLinkPromptPage(email: testEmail),
      );
      expect(find.byType(MagicLinkPromptView), findsOneWidget);
    });

    group('navigates', () {
      testWidgets('back when pressed on close icon', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
        when(() => navigator.popUntil(any())).thenAnswer((_) async {});
        await tester.pumpApp(
          const MagicLinkPromptPage(email: testEmail),
          navigator: navigator,
        );

        await tester.tap(find.byKey(magicLinkPromptCloseIconKey));
        await tester.pumpAndSettle();
        verify(() => navigator.popUntil(any())).called(1);
      });

      testWidgets('back when leading button is pressed.', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
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
