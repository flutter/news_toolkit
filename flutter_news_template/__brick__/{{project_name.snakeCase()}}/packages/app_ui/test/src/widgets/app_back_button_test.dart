import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../helpers/helpers.dart';

class MockFunction extends Mock {
  void call();
}

void main() {
  group('AppBackButton', () {
    testWidgets('renders IconButton', (tester) async {
      await tester.pumpApp(
        Scaffold(
          appBar: AppBar(
            leading: const AppBackButton(),
          ),
        ),
      );

      expect(
        find.byType(IconButton),
        findsOneWidget,
      );
    });

    testWidgets('renders IconButton when light', (tester) async {
      await tester.pumpApp(
        Scaffold(
          appBar: AppBar(
            leading: const AppBackButton.light(),
          ),
        ),
      );

      expect(
        find.byType(IconButton),
        findsOneWidget,
      );
    });

    group('navigates', () {
      testWidgets('back when press the icon button', (tester) async {
        final navigator = MockNavigator();
        when(navigator.canPop).thenAnswer((_) => true);
        when(navigator.pop).thenAnswer((_) async {});
        await tester.pumpApp(
          const AppBackButton(),
          navigator: navigator,
        );
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        verify(navigator.pop).called(1);
      });

      testWidgets('call onPressed when is provided ', (tester) async {
        final onPressed = MockFunction();
        await tester.pumpApp(
          AppBackButton(onPressed: onPressed.call),
        );
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        verify(onPressed.call).called(1);
      });

      testWidgets(
          'call onPressed when is provided '
          'and style is light', (tester) async {
        final onPressed = MockFunction();
        await tester.pumpApp(
          AppBackButton.light(onPressed: onPressed.call),
        );
        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();
        verify(onPressed.call).called(1);
      });
    });
  });
}
