import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscribe/widgets/widgets.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const closesModalKey = Key('subscribePayWallModal_closeModal');
  const subscribePayWallTitleKey = Key('susbcribePayWallModal_title');
  const subscribePayWallSubtitleKey = Key('susbcribePayWallModal_subtitle');
  const susbscribePayWallSubscribeButtonKey =
      Key('susbcribePayWallModal_subscribeButton');
  const susbcribePayWallWatchVideoButtonKey =
      Key('susbcribePayWallModal_watchVideo');

  group('renders', () {
    testWidgets('Subscribe paywall modal title', (tester) async {
      await tester.pumpApp(
        const SubscribePayWallModal(),
      );
      expect(find.byKey(subscribePayWallTitleKey), findsOneWidget);
    });

    testWidgets('Subscribe paywall modal subtitle', (tester) async {
      await tester.pumpApp(
        const SubscribePayWallModal(),
      );
      expect(find.byKey(subscribePayWallSubtitleKey), findsOneWidget);
    });

    testWidgets('Subscribe paywall modal subscribe button', (tester) async {
      await tester.pumpApp(
        const SubscribePayWallModal(),
      );
      expect(find.byKey(susbscribePayWallSubscribeButtonKey), findsOneWidget);
    });

    testWidgets('Subscribe paywall modal watch video button', (tester) async {
      await tester.pumpApp(
        const SubscribePayWallModal(),
      );
      expect(find.byKey(susbscribePayWallSubscribeButtonKey), findsOneWidget);
    });
  });

  group('closes modal', () {
    testWidgets('when the close icon is pressed', (tester) async {
      final navigator = MockNavigator();
      when(navigator.pop).thenAnswer((_) async {});
      await tester.pumpApp(
        const SubscribePayWallModal(),
        navigator: navigator,
      );
      await tester.ensureVisible(find.byKey(closesModalKey));
      await tester.tap(find.byKey(closesModalKey));
      await tester.pumpAndSettle();
      verify(navigator.pop).called(1);
    });

    group('does nothing', () {
      testWidgets('when subscribe watch video button is pressed',
          (tester) async {
        await tester.pumpApp(
          const SubscribePayWallModal(),
        );
        await tester
            .ensureVisible(find.byKey(susbscribePayWallSubscribeButtonKey));

        await tester.tap(find.byKey(susbscribePayWallSubscribeButtonKey));
        await tester.pumpAndSettle();
        expect(
          find.byKey(susbscribePayWallSubscribeButtonKey),
          findsOneWidget,
        );
      });
      testWidgets('when paywall watch video button is pressed', (tester) async {
        await tester.pumpApp(
          const SubscribePayWallModal(),
        );
        await tester
            .ensureVisible(find.byKey(susbcribePayWallWatchVideoButtonKey));

        await tester.tap(find.byKey(susbcribePayWallWatchVideoButtonKey));
        await tester.pumpAndSettle();
        expect(
          find.byKey(susbcribePayWallWatchVideoButtonKey),
          findsOneWidget,
        );
      });
    });
  });
}
