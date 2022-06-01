import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscribe/widgets/widgets.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const closesModalKey = Key('subscribeLoggedInModal_closeModal');
  const subscribeLoggedInTitleKey = Key('subscribeLoggedInModal_title');
  const subscribeLoggedInSubtitleKey = Key('subscribeLoggedInModal_subtitle');
  const subscribeLoggedInSubscribeButtonKey =
      Key('subscribeLoggedInModal_subscribeButton');

  group('renders', () {
    testWidgets('Subscribe logged in modal title', (tester) async {
      await tester.pumpApp(
        const SubscribeLoggedInModal(),
      );
      expect(find.byKey(subscribeLoggedInTitleKey), findsOneWidget);
    });

    testWidgets('Subscribe logged in modal subtitle', (tester) async {
      await tester.pumpApp(
        const SubscribeLoggedInModal(),
      );
      expect(find.byKey(subscribeLoggedInSubtitleKey), findsOneWidget);
    });

    testWidgets('Subscribe logged in modal subscribe button', (tester) async {
      await tester.pumpApp(
        const SubscribeLoggedInModal(),
      );
      expect(find.byKey(subscribeLoggedInSubscribeButtonKey), findsOneWidget);
    });
  });

  group('closes modal', () {
    testWidgets('when the close icon is pressed', (tester) async {
      final navigator = MockNavigator();
      when(navigator.pop).thenAnswer((_) async {});
      await tester.pumpApp(
        const SubscribeLoggedInModal(),
        navigator: navigator,
      );
      await tester.tap(find.byKey(closesModalKey));
      await tester.pumpAndSettle();
      verify(navigator.pop).called(1);
    });

    group('does nothing', () {
      testWidgets('when logged in subscribe button is pressed', (tester) async {
        await tester.pumpApp(
          const SubscribeLoggedInModal(),
        );
        await tester
            .ensureVisible(find.byKey(subscribeLoggedInSubscribeButtonKey));

        await tester.tap(find.byKey(subscribeLoggedInSubscribeButtonKey));
        await tester.pumpAndSettle();
        expect(
          find.byKey(subscribeLoggedInSubscribeButtonKey),
          findsOneWidget,
        );
      });
    });
  });
}
