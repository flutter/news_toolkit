// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:flutter_news_template/ads/ads.dart';

class FakeInterstitialAd extends Fake implements ads.InterstitialAd {}

class FakeRewardedAd extends Fake implements ads.RewardedAd {}

class FakeRewardItem extends Fake implements ads.RewardItem {}

void main() {
  group('FullScreenAdsState', () {
    test('supports value comparisons', () {
      final interstitialAd = FakeInterstitialAd();
      final rewardedAd = FakeRewardedAd();
      final earnedReward = FakeRewardItem();

      expect(
        FullScreenAdsState(
          interstitialAd: interstitialAd,
          rewardedAd: rewardedAd,
          earnedReward: earnedReward,
          status: FullScreenAdsStatus.initial,
        ),
        equals(
          FullScreenAdsState(
            interstitialAd: interstitialAd,
            rewardedAd: rewardedAd,
            earnedReward: earnedReward,
            status: FullScreenAdsStatus.initial,
          ),
        ),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          FullScreenAdsState.initial().copyWith(),
          equals(FullScreenAdsState.initial()),
        );
      });

      test(
          'returns object with updated interstitialAd '
          'when interstitialAd is passed', () {
        final interstitialAd = FakeInterstitialAd();
        expect(
          FullScreenAdsState.initial().copyWith(interstitialAd: interstitialAd),
          equals(
            FullScreenAdsState(
              status: FullScreenAdsStatus.initial,
              interstitialAd: interstitialAd,
            ),
          ),
        );
      });

      test(
          'returns object with updated rewardedAd '
          'when rewardedAd is passed', () {
        final rewardedAd = FakeRewardedAd();
        expect(
          FullScreenAdsState.initial().copyWith(rewardedAd: rewardedAd),
          equals(
            FullScreenAdsState(
              status: FullScreenAdsStatus.initial,
              rewardedAd: rewardedAd,
            ),
          ),
        );
      });

      test(
          'returns object with updated earnedReward '
          'when earnedReward is passed', () {
        final earnedReward = FakeRewardItem();
        expect(
          FullScreenAdsState.initial().copyWith(earnedReward: earnedReward),
          equals(
            FullScreenAdsState(
              status: FullScreenAdsStatus.initial,
              earnedReward: earnedReward,
            ),
          ),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        const status = FullScreenAdsStatus.showingInterstitialAd;
        expect(
          FullScreenAdsState.initial().copyWith(status: status),
          equals(
            FullScreenAdsState(status: status),
          ),
        );
      });
    });
  });
}
