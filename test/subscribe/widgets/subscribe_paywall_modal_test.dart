import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/subscribe/widgets/widgets.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const closesModalKey = Key('subscribePayWallModal_closeModal');
  const subscribePayWallTitleKey = Key('subscribePayWallModal_title');
  const subscribePayWallSubtitleKey = Key('subscribePayWallModal_subtitle');
  const subscribePayWallSubscribeButtonKey =
      Key('subscribePayWallModal_subscribeButton');
  const subscribePayWallWatchVideoButtonKey =
      Key('subscribePayWallModal_watchVideo');

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
      expect(find.byKey(subscribePayWallSubscribeButtonKey), findsOneWidget);
    });

    testWidgets('Subscribe paywall modal watch video button', (tester) async {
      await tester.pumpApp(
        const SubscribePayWallModal(),
      );
      expect(find.byKey(subscribePayWallSubscribeButtonKey), findsOneWidget);
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
            .ensureVisible(find.byKey(subscribePayWallSubscribeButtonKey));

        await tester.tap(find.byKey(subscribePayWallSubscribeButtonKey));
        await tester.pumpAndSettle();
        expect(
          find.byKey(subscribePayWallSubscribeButtonKey),
          findsOneWidget,
        );
      });
      testWidgets('when paywall watch video button is pressed', (tester) async {
        await tester.pumpApp(
          const SubscribePayWallModal(),
        );
        await tester
            .ensureVisible(find.byKey(subscribePayWallWatchVideoButtonKey));

        await tester.tap(find.byKey(subscribePayWallWatchVideoButtonKey));
        await tester.pumpAndSettle();
        expect(
          find.byKey(subscribePayWallWatchVideoButtonKey),
          findsOneWidget,
        );
      });
    });
  });
}
