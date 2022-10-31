// ignore_for_file: prefer_const_constructors

import 'package:flutter_news_example/ads/ads.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;

class FakeRewardItem extends Fake implements ads.RewardItem {}

void main() {
  group('FullScreenAdsEvent', () {
    group('LoadInterstitialAdRequested', () {
      test('supports value comparisons', () {
        expect(LoadInterstitialAdRequested(), LoadInterstitialAdRequested());
      });
    });

    group('LoadRewardedAdRequested', () {
      test('supports value comparisons', () {
        expect(LoadRewardedAdRequested(), LoadRewardedAdRequested());
      });
    });

    group('ShowInterstitialAdRequested', () {
      test('supports value comparisons', () {
        expect(ShowInterstitialAdRequested(), ShowInterstitialAdRequested());
      });
    });

    group('ShowRewardedAdRequested', () {
      test('supports value comparisons', () {
        expect(ShowRewardedAdRequested(), ShowRewardedAdRequested());
      });
    });

    group('EarnedReward', () {
      test('supports value comparisons', () {
        final reward = FakeRewardItem();
        expect(EarnedReward(reward), EarnedReward(reward));
      });
    });
  });
}
