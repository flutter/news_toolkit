// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';
import 'package:platform/platform.dart';

import '../../helpers/helpers.dart';

class MockBannerAd extends Mock implements BannerAd {}

class MockPlatform extends Mock implements Platform {}

class MockLoadAdError extends Mock implements LoadAdError {}

void main() {
  group('BannerAdContent', () {
    late AdSize capturedSize;
    late String capturedAdUnitId;
    late BannerAdListener capturedListener;

    late Platform platform;
    late BannerAd ad;
    late BannerAdBuilder adBuilder;

    setUp(() {
      platform = MockPlatform();
      when(() => platform.isAndroid).thenReturn(true);
      when(() => platform.isIOS).thenReturn(false);

      ad = MockBannerAd();
      when(ad.load).thenAnswer((_) async {});
      when(() => ad.size).thenReturn(AdSize.banner);
      when(ad.dispose).thenAnswer((_) async {});

      adBuilder = ({
        required AdSize size,
        required String adUnitId,
        required BannerAdListener listener,
        required AdRequest request,
      }) {
        capturedSize = size;
        capturedAdUnitId = adUnitId;
        capturedListener = listener;
        return ad;
      };
    });

    testWidgets(
        'loads ad object correctly '
        'on Android', (tester) async {
      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      expect(capturedAdUnitId, equals(BannerAdContent.androidTestUnitId));

      verify(ad.load).called(1);
    });

    testWidgets(
        'loads ad object correctly '
        'on iOS', (tester) async {
      when(() => platform.isIOS).thenReturn(true);
      when(() => platform.isAndroid).thenReturn(false);

      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.anchoredAdaptive,
          adBuilder: adBuilder,
          currentPlatform: platform,
          anchoredAdaptiveAdSizeProvider: (orientation, width) async =>
              AnchoredAdaptiveBannerAdSize(
            Orientation.portrait,
            width: 100,
            height: 100,
          ),
        ),
      );

      expect(capturedAdUnitId, equals(BannerAdContent.iosTestUnitAd));

      verify(ad.load).called(1);
    });

    testWidgets(
        'loads ad object correctly '
        'with provided adUnitId', (tester) async {
      const adUnitId = 'adUnitId';

      await tester.pumpApp(
        BannerAdContent(
          adUnitId: adUnitId,
          size: BannerAdSize.anchoredAdaptive,
          adBuilder: adBuilder,
          currentPlatform: platform,
          anchoredAdaptiveAdSizeProvider: (orientation, width) async =>
              AnchoredAdaptiveBannerAdSize(
            Orientation.portrait,
            width: 100,
            height: 100,
          ),
        ),
      );

      expect(capturedAdUnitId, equals(adUnitId));

      verify(ad.load).called(1);
    });

    testWidgets(
        'renders ProgressIndicator '
        'when ad is loading '
        'and showProgressIndicator is true', (tester) async {
      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      expect(find.byType(ProgressIndicator), findsOneWidget);
      expect(find.byType(AdWidget), findsNothing);
    });

    testWidgets(
        'does not render ProgressIndicator '
        'when ad is loading '
        'and showProgressIndicator is false', (tester) async {
      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
          showProgressIndicator: false,
        ),
      );

      expect(find.byType(ProgressIndicator), findsNothing);
      expect(find.byType(AdWidget), findsNothing);
    });

    testWidgets('renders AdWidget when ad is loaded', (tester) async {
      ad = BannerAd(
        size: AdSize.banner,
        adUnitId: BannerAdContent.androidTestUnitId,
        listener: BannerAdListener(),
        request: AdRequest(),
      );

      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      capturedListener.onAdLoaded!(ad);
      await tester.pumpAndSettle();

      expect(find.byType(AdWidget), findsOneWidget);
      expect(find.byType(ProgressIndicator), findsNothing);
    });

    testWidgets('uses AdSize.banner for BannerAdSize.normal', (tester) async {
      const expectedSize = AdSize.banner;
      when(() => ad.size).thenReturn(expectedSize);

      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      expect(capturedSize, equals(expectedSize));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.key == Key('bannerAdContent_sizedBox') &&
              widget is SizedBox &&
              widget.width == expectedSize.width &&
              widget.height == expectedSize.height,
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses AdSize.mediumRectangle for BannerAdSize.large',
        (tester) async {
      const expectedSize = AdSize.mediumRectangle;
      when(() => ad.size).thenReturn(expectedSize);

      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.large,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      expect(capturedSize, equals(expectedSize));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.key == Key('bannerAdContent_sizedBox') &&
              widget is SizedBox &&
              widget.width == expectedSize.width &&
              widget.height == expectedSize.height,
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses AdSize(300, 600) for BannerAdSize.extraLarge',
        (tester) async {
      const expectedSize = AdSize(width: 300, height: 600);
      when(() => ad.size).thenReturn(expectedSize);

      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.extraLarge,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      expect(capturedSize, equals(expectedSize));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget.key == Key('bannerAdContent_sizedBox') &&
              widget is SizedBox &&
              widget.width == expectedSize.width &&
              widget.height == expectedSize.height,
        ),
        findsOneWidget,
      );
    });

    testWidgets('disposes ad object on widget dispose', (tester) async {
      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.normal,
          adBuilder: adBuilder,
          currentPlatform: platform,
        ),
      );

      // Pump another widget so the tested widget is disposed.
      await tester.pumpApp(SizedBox());

      verify(ad.dispose).called(1);
    });

    testWidgets(
        'retries loading ad based on AdsRetryPolicy '
        'and renders placeholder '
        'when ad fails to load', (tester) async {
      final fakeAsync = FakeAsync();
      const adFailedToLoadTitle = 'adFailedToLoadTitle';
      final adsRetryPolicy = AdsRetryPolicy();

      adBuilder = ({
        required AdSize size,
        required String adUnitId,
        required BannerAdListener listener,
        required AdRequest request,
      }) {
        Future.microtask(
          () => listener.onAdFailedToLoad!(
            ad,
            LoadAdError(0, 'domain', 'message', null),
          ),
        );
        return ad;
      };

      final errors = <Object>[];
      FlutterError.onError = (error) => errors.add(error.exception);

      unawaited(
        fakeAsync.run((async) async {
          await tester.pumpApp(
            BannerAdContent(
              adFailedToLoadTitle: adFailedToLoadTitle,
              size: BannerAdSize.normal,
              adBuilder: adBuilder,
              currentPlatform: platform,
              adsRetryPolicy: adsRetryPolicy,
            ),
          );

          await tester.pump();
          expect(find.text(adFailedToLoadTitle), findsNothing);

          for (var i = 1; i <= adsRetryPolicy.maxRetryCount; i++) {
            await tester.pump();
            expect(find.text(adFailedToLoadTitle), findsNothing);
            async.elapse(adsRetryPolicy.getIntervalForRetry(i));
          }

          await tester.pump();
          expect(find.text(adFailedToLoadTitle), findsOneWidget);
        }),
      );

      fakeAsync.flushMicrotasks();

      expect(
        errors,
        equals([
          // Initial load attempt failure.
          isA<BannerAdFailedToLoadException>(),

          // Retry load attempt failures.
          for (var i = 1; i <= adsRetryPolicy.maxRetryCount; i++)
            isA<BannerAdFailedToLoadException>(),
        ]),
      );
    });

    testWidgets(
        'throws BannerAdFailedToGetSizeException '
        'for BannerAdSize.anchoredAdaptive '
        'when ad size fails to load', (tester) async {
      await tester.pumpApp(
        BannerAdContent(
          size: BannerAdSize.anchoredAdaptive,
          adBuilder: adBuilder,
          currentPlatform: platform,
          anchoredAdaptiveAdSizeProvider: (orientation, width) async => null,
        ),
      );

      expect(
        tester.takeException(),
        isA<BannerAdFailedToGetSizeException>(),
      );
    });
  });
}
