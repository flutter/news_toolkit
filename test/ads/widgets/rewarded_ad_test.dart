// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart' hide ProgressIndicator;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:google_news_template/ads/ads.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

import '../../helpers/helpers.dart';

class MockRewardedAd extends Mock implements ads.RewardedAd {}

class FakeRewardedAd extends Fake implements ads.RewardedAd {
  ads.FullScreenContentCallback<ads.RewardedAd>? contentCallback;
  bool disposeCalled = false;

  @override
  Future<void> show({
    required ads.OnUserEarnedRewardCallback onUserEarnedReward,
  }) async {}

  @override
  Future<void> dispose() async => disposeCalled = true;

  @override
  set fullScreenContentCallback(
    ads.FullScreenContentCallback<ads.RewardedAd>? fullScreenContentCallback,
  ) {
    contentCallback = fullScreenContentCallback;
  }

  @override
  ads.FullScreenContentCallback<ads.RewardedAd>?
      get fullScreenContentCallback => contentCallback;
}

class MockRewardItem extends Mock implements ads.RewardItem {}

class MockPlatform extends Mock implements Platform {}

class MockLoadAdError extends Mock implements ads.LoadAdError {}

void main() {
  group('RewardedAd', () {
    late String capturedAdUnitId;
    late ads.RewardedAdLoadCallback capturedAdLoadCallback;

    late Platform platform;
    late ads.RewardedAd ad;
    late RewardedAdLoader adLoader;

    setUp(() {
      platform = MockPlatform();
      when(() => platform.isAndroid).thenReturn(true);
      when(() => platform.isIOS).thenReturn(false);

      ad = MockRewardedAd();
      when(() => ad.show(onUserEarnedReward: any(named: 'onUserEarnedReward')))
          .thenAnswer((_) async {});
      when(ad.dispose).thenAnswer((_) async {});

      adLoader = ({
        required String adUnitId,
        required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
        required ads.AdRequest request,
      }) async {
        capturedAdUnitId = adUnitId;
        capturedAdLoadCallback = rewardedAdLoadCallback;
      };
    });

    testWidgets(
        'loads ad object correctly '
        'on Android', (tester) async {
      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      expect(capturedAdUnitId, equals(RewardedAd.androidTestUnitId));
    });

    testWidgets(
        'loads ad object correctly '
        'on iOS', (tester) async {
      when(() => platform.isIOS).thenReturn(true);
      when(() => platform.isAndroid).thenReturn(false);

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      expect(capturedAdUnitId, equals(RewardedAd.iosTestUnitAd));
    });

    testWidgets(
        'loads ad object correctly '
        'with provided adUnitId', (tester) async {
      const adUnitId = 'adUnitId';

      await tester.pumpApp(
        RewardedAd(
          adUnitId: adUnitId,
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      expect(capturedAdUnitId, equals(adUnitId));
    });

    testWidgets('shows ad object when ad is loaded', (tester) async {
      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);

      verify(
        () => ad.show(onUserEarnedReward: any(named: 'onUserEarnedReward')),
      ).called(1);
    });

    testWidgets('calls onUserEarnedReward when ad is rewarded', (tester) async {
      late ads.RewardItem capturedRewardItem;
      var onUserEarnedRewardCalled = false;

      // Mock ad.show to call onUserEarnedReward immediately
      // with expectedRewardItem.
      final expectedRewardItem = MockRewardItem();
      when(() => ad.show(onUserEarnedReward: any(named: 'onUserEarnedReward')))
          .thenAnswer((invocation) async {
        (invocation.namedArguments[Symbol('onUserEarnedReward')]
                as ads.OnUserEarnedRewardCallback)
            .call(ad, expectedRewardItem);
      });

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {
            onUserEarnedRewardCalled = true;
            capturedRewardItem = reward;
          },
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);

      expect(onUserEarnedRewardCalled, isTrue);
      expect(capturedRewardItem, equals(expectedRewardItem));
    });

    testWidgets('renders child', (tester) async {
      const childKey = Key('__child__');

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(key: childKey),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('disposes ad object on widget dispose', (tester) async {
      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);

      // Pump another widget so the tested widget is disposed.
      await tester.pumpApp(SizedBox());

      verify(ad.dispose).called(1);
    });

    testWidgets(
        'disposes ad object '
        'and calls onDismissed '
        'on ad dismissed', (tester) async {
      final ad = FakeRewardedAd();
      var _onDismissedCalled = false;

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
          onDismissed: () => _onDismissedCalled = true,
        ),
      );

      capturedAdLoadCallback.onAdLoaded(ad);
      await tester.pump();

      ad.fullScreenContentCallback!.onAdDismissedFullScreenContent!(ad);

      expect(ad.disposeCalled, isTrue);
      expect(_onDismissedCalled, isTrue);
    });

    testWidgets(
        'throws RewardedAdFailedToLoadException '
        'and calls onFailedToLoad '
        'when ad fails to load', (tester) async {
      var _onFailedToLoadCalled = false;

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
          onFailedToLoad: () => _onFailedToLoadCalled = true,
        ),
      );

      final error = MockLoadAdError();
      capturedAdLoadCallback.onAdFailedToLoad(error);

      expect(
        tester.takeException(),
        isA<RewardedAdFailedToLoadException>(),
      );

      expect(_onFailedToLoadCalled, isTrue);
    });

    testWidgets(
        'throws RewardedAdFailedToLoadException '
        'and disposes ad object '
        'and calls onFailedToLoad '
        'when ad fails to show', (tester) async {
      final ad = FakeRewardedAd();
      var _onFailedToLoadCalled = false;

      await tester.pumpApp(
        RewardedAd(
          adLoader: adLoader,
          currentPlatform: platform,
          child: const SizedBox(),
          onUserEarnedReward: (ad, reward) {},
          onFailedToLoad: () => _onFailedToLoadCalled = true,
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
        isA<RewardedAdFailedToLoadException>(),
      );

      expect(ad.disposeCalled, isTrue);
      expect(_onFailedToLoadCalled, isTrue);
    });
  });
}
