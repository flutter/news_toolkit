// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:google_news_template/ads/ads.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

import '../../helpers/helpers.dart';

class MockInterstitialAd extends Mock implements ads.InterstitialAd {}

class FakeInterstitialAd extends Fake implements ads.InterstitialAd {
  ads.FullScreenContentCallback<ads.InterstitialAd>? contentCallback;
  bool disposeCalled = false;

  @override
  Future<void> show() async {}

  @override
  Future<void> dispose() async => disposeCalled = true;

  @override
  set fullScreenContentCallback(
    ads.FullScreenContentCallback<ads.InterstitialAd>?
        fullScreenContentCallback,
  ) {
    contentCallback = fullScreenContentCallback;
  }

  @override
  ads.FullScreenContentCallback<ads.InterstitialAd>?
      get fullScreenContentCallback => contentCallback;
}

class MockPlatform extends Mock implements Platform {}

class MockLoadAdError extends Mock implements ads.LoadAdError {}

void main() {
  group('InterstitialAd', () {
    late String capturedAdUnitId;
    late ads.InterstitialAdLoadCallback capturedAdLoadCallback;

    late Platform platform;
    late ads.InterstitialAd ad;
    late InterstitialAdLoader adLoader;

    setUp(() {
      platform = MockPlatform();
      when(() => platform.isAndroid).thenReturn(true);
      when(() => platform.isIOS).thenReturn(false);

      ad = MockInterstitialAd();
      when(ad.show).thenAnswer((_) async {});
      when(ad.dispose).thenAnswer((_) async {});

      adLoader = ({
        required String adUnitId,
        required ads.InterstitialAdLoadCallback adLoadCallback,
        required ads.AdRequest request,
      }) async {
        capturedAdUnitId = adUnitId;
        capturedAdLoadCallback = adLoadCallback;
      };
    });

    testWidgets(
        'loads ad object correctly '
        'on Android', (tester) async {
      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      expect(capturedAdUnitId, equals(InterstitialAd.androidTestUnitId));
    });

    testWidgets(
        'loads ad object correctly '
        'on iOS', (tester) async {
      when(() => platform.isIOS).thenReturn(true);
      when(() => platform.isAndroid).thenReturn(false);

      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      expect(capturedAdUnitId, equals(InterstitialAd.iosTestUnitAd));
    });

    testWidgets(
        'loads ad object correctly '
        'with provided adUnitId', (tester) async {
      const adUnitId = 'adUnitId';

      await tester.pumpApp(
        InterstitialAd(
          adUnitId: adUnitId,
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      expect(capturedAdUnitId, equals(adUnitId));
    });

    testWidgets('shows ad object when ad is loaded', (tester) async {
      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);

      verify(ad.show).called(1);
    });

    testWidgets('renders child', (tester) async {
      const childKey = Key('__child__');

      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(key: childKey),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('disposes ad object on widget dispose', (tester) async {
      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);

      // Pump another widget so the tested widget is disposed.
      await tester.pumpApp(SizedBox());

      verify(ad.dispose).called(1);
    });

    testWidgets('disposes ad object on ad dismissed', (tester) async {
      final ad = FakeInterstitialAd();

      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);
      await tester.pump();

      ad.fullScreenContentCallback!.onAdDismissedFullScreenContent!(ad);

      expect(ad.disposeCalled, isTrue);
    });

    testWidgets(
        'throws InterstitialAdFailedToLoadException '
        'when ad fails to load', (tester) async {
      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      final error = MockLoadAdError();
      capturedAdLoadCallback.onAdFailedToLoad(error);

      expect(
        tester.takeException(),
        isA<InterstitialAdFailedToLoadException>(),
      );
    });

    testWidgets(
        'throws InterstitialAdFailedToLoadException '
        'and disposes ad object '
        'when ad fails to show', (tester) async {
      final ad = FakeInterstitialAd();

      await tester.pumpApp(
        InterstitialAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);
      await tester.pump();

      final error = MockLoadAdError();
      ad.fullScreenContentCallback!.onAdFailedToShowFullScreenContent!(
        ad,
        error,
      );

      expect(
        tester.takeException(),
        isA<InterstitialAdFailedToLoadException>(),
      );

      expect(ad.disposeCalled, isTrue);
    });
  });
}
