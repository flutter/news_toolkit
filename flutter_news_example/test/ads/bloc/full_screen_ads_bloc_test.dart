// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;
import 'package:flutter_news_template/ads/ads.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:platform/platform.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

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

class MockLoadAdError extends Mock implements ads.LoadAdError {}

class MockLocalPlatform extends Mock implements LocalPlatform {}

void main() {
  group('FullScreenAdsBloc', () {
    String? capturedAdUnitId;

    late LocalPlatform localPlatform;
    late ads.InterstitialAd interstitialAd;
    late InterstitialAdLoader interstitialAdLoader;
    late ads.RewardedAd rewardedAd;
    late RewardedAdLoader rewardedAdLoader;

    setUp(() {
      localPlatform = MockLocalPlatform();
      when(() => localPlatform.isAndroid).thenReturn(true);
      when(() => localPlatform.isIOS).thenReturn(false);

      interstitialAd = MockInterstitialAd();
      when(interstitialAd.show).thenAnswer((_) async {});
      when(interstitialAd.dispose).thenAnswer((_) async {});

      interstitialAdLoader = ({
        required String adUnitId,
        required ads.InterstitialAdLoadCallback adLoadCallback,
        required ads.AdRequest request,
      }) async {
        capturedAdUnitId = adUnitId;
      };

      rewardedAd = MockRewardedAd();
      when(
        () => rewardedAd.show(
          onUserEarnedReward: any(named: 'onUserEarnedReward'),
        ),
      ).thenAnswer((_) async {});
      when(rewardedAd.dispose).thenAnswer((_) async {});

      rewardedAdLoader = ({
        required String adUnitId,
        required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
        required ads.AdRequest request,
      }) async {
        capturedAdUnitId = adUnitId;
      };
    });

    test('can be instantiated', () {
      expect(
        FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        isNotNull,
      );
    });

    group('LoadInterstitialAdRequested', () {
      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly on Android',
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadInterstitialAdRequested()),
        verify: (bloc) {
          expect(
            capturedAdUnitId,
            equals(FullScreenAdsConfig.androidTestInterstitialAdUnitId),
          );
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly on iOS',
        setUp: () {
          when(() => localPlatform.isIOS).thenReturn(true);
          when(() => localPlatform.isAndroid).thenReturn(false);
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadInterstitialAdRequested()),
        verify: (bloc) {
          expect(
            capturedAdUnitId,
            equals(FullScreenAdsConfig.iosTestInterstitialAdUnitId),
          );
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly using provided FullScreenAdsConfig',
        setUp: () {
          when(() => localPlatform.isIOS).thenReturn(true);
          when(() => localPlatform.isAndroid).thenReturn(false);
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
          fullScreenAdsConfig:
              FullScreenAdsConfig(interstitialAdUnitId: 'interstitialAdUnitId'),
        ),
        act: (bloc) => bloc.add(LoadInterstitialAdRequested()),
        verify: (bloc) {
          expect(capturedAdUnitId, equals('interstitialAdUnitId'));
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'emits ad when ad is loaded',
        setUp: () {
          interstitialAdLoader = ({
            required String adUnitId,
            required ads.InterstitialAdLoadCallback adLoadCallback,
            required ads.AdRequest request,
          }) async {
            await Future.microtask(
              () => adLoadCallback.onAdLoaded(interstitialAd),
            );
          };
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadInterstitialAdRequested()),
        expect: () => [
          FullScreenAdsState(status: FullScreenAdsStatus.loadingInterstitialAd),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
            interstitialAd: interstitialAd,
          ),
        ],
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'adds error when ad fails to load',
        setUp: () {
          interstitialAdLoader = ({
            required String adUnitId,
            required ads.InterstitialAdLoadCallback adLoadCallback,
            required ads.AdRequest request,
          }) async {
            await Future.microtask(
              () => adLoadCallback.onAdFailedToLoad(
                ads.LoadAdError(0, 'domain', 'message', null),
              ),
            );
          };
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadInterstitialAdRequested()),
        expect: () => [
          FullScreenAdsState(status: FullScreenAdsStatus.loadingInterstitialAd),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingInterstitialAdFailed,
          ),
        ],
        errors: () => [isA<ads.LoadAdError>()],
      );

      test('retries loading ad based on AdsRetryPolicy', () async {
        final fakeAsync = FakeAsync();

        unawaited(
          fakeAsync.run((async) async {
            final adsRetryPolicy = AdsRetryPolicy();

            interstitialAdLoader = ({
              required String adUnitId,
              required ads.InterstitialAdLoadCallback adLoadCallback,
              required ads.AdRequest request,
            }) async {
              await Future.microtask(
                () => adLoadCallback.onAdFailedToLoad(
                  ads.LoadAdError(0, 'domain', 'message', null),
                ),
              );
            };

            final bloc = FullScreenAdsBloc(
              adsRetryPolicy: adsRetryPolicy,
              localPlatform: localPlatform,
              interstitialAdLoader: interstitialAdLoader,
              rewardedAdLoader: rewardedAdLoader,
            )..add(LoadInterstitialAdRequested());

            expect(
              (await bloc.stream.first).status,
              equals(FullScreenAdsStatus.loadingInterstitialAd),
            );

            expect(
              (await bloc.stream.first).status,
              equals(FullScreenAdsStatus.loadingInterstitialAdFailed),
            );

            for (var i = 1; i <= adsRetryPolicy.maxRetryCount; i++) {
              expect(
                bloc.stream,
                emitsInOrder(
                  <FullScreenAdsState>[
                    FullScreenAdsState(
                      status: FullScreenAdsStatus.loadingInterstitialAd,
                    ),
                    FullScreenAdsState(
                      status: FullScreenAdsStatus.loadingInterstitialAdFailed,
                    ),
                  ],
                ),
              );
              async.elapse(adsRetryPolicy.getIntervalForRetry(i));
            }
          }),
        );

        fakeAsync.flushMicrotasks();
      });
    });

    group('ShowInterstitialAdRequested', () {
      final ad = FakeInterstitialAd();

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'shows ad and loads next ad',
        seed: () => FullScreenAdsState(
          status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
          interstitialAd: interstitialAd,
        ),
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(ShowInterstitialAdRequested()),
        expect: () => [
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingInterstitialAd,
            interstitialAd: interstitialAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingInterstitialAdSucceeded,
            interstitialAd: interstitialAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingInterstitialAd,
            interstitialAd: interstitialAd,
          ),
        ],
        verify: (bloc) {
          verify(interstitialAd.show).called(1);
        },
      );

      test('disposes ad on ad dismissed', () async {
        final bloc = FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        )
          ..emit(
            FullScreenAdsState(
              status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
              interstitialAd: ad,
            ),
          )
          ..add(ShowInterstitialAdRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<FullScreenAdsState>[
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingInterstitialAd,
              interstitialAd: ad,
            ),
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingInterstitialAdSucceeded,
              interstitialAd: ad,
            ),
          ]),
        );

        ad.fullScreenContentCallback!.onAdDismissedFullScreenContent!(ad);

        expect(ad.disposeCalled, isTrue);
      });

      test('disposes ad when ads fails to show', () async {
        final bloc = FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        )
          ..emit(
            FullScreenAdsState(
              status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
              interstitialAd: ad,
            ),
          )
          ..add(ShowInterstitialAdRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<FullScreenAdsState>[
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingInterstitialAd,
              interstitialAd: ad,
            ),
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingInterstitialAdSucceeded,
              interstitialAd: ad,
            ),
          ]),
        );

        final error = MockLoadAdError();
        ad.fullScreenContentCallback!.onAdFailedToShowFullScreenContent!(
          ad,
          error,
        );

        expect(ad.disposeCalled, isTrue);
      });

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'adds error when ad fails to show',
        seed: () => FullScreenAdsState(
          status: FullScreenAdsStatus.loadingInterstitialAdSucceeded,
          interstitialAd: interstitialAd,
        ),
        setUp: () {
          when(interstitialAd.show).thenThrow(Exception('Oops'));
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(ShowInterstitialAdRequested()),
        expect: () => [
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingInterstitialAd,
            interstitialAd: interstitialAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingInterstitialAdFailed,
            interstitialAd: interstitialAd,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('LoadRewardedAdRequested', () {
      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly on Android',
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadRewardedAdRequested()),
        verify: (bloc) {
          expect(
            capturedAdUnitId,
            equals(FullScreenAdsConfig.androidTestRewardedAdUnitId),
          );
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly on iOS',
        setUp: () {
          when(() => localPlatform.isIOS).thenReturn(true);
          when(() => localPlatform.isAndroid).thenReturn(false);
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadRewardedAdRequested()),
        verify: (bloc) {
          expect(
            capturedAdUnitId,
            equals(FullScreenAdsConfig.iosTestRewardedAdUnitId),
          );
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'loads ad object correctly using provided FullScreenAdsConfig',
        setUp: () {
          when(() => localPlatform.isIOS).thenReturn(true);
          when(() => localPlatform.isAndroid).thenReturn(false);
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
          fullScreenAdsConfig:
              FullScreenAdsConfig(rewardedAdUnitId: 'rewardedAdUnitId'),
        ),
        act: (bloc) => bloc.add(LoadRewardedAdRequested()),
        verify: (bloc) {
          expect(capturedAdUnitId, equals('rewardedAdUnitId'));
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'emits ad when ad is loaded',
        setUp: () {
          rewardedAdLoader = ({
            required String adUnitId,
            required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
            required ads.AdRequest request,
          }) async {
            await Future.microtask(
              () => rewardedAdLoadCallback.onAdLoaded(rewardedAd),
            );
          };
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadRewardedAdRequested()),
        expect: () => [
          FullScreenAdsState(status: FullScreenAdsStatus.loadingRewardedAd),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
            rewardedAd: rewardedAd,
          ),
        ],
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'adds error when ad fails to load',
        setUp: () {
          rewardedAdLoader = ({
            required String adUnitId,
            required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
            required ads.AdRequest request,
          }) async {
            await Future.microtask(
              () => rewardedAdLoadCallback.onAdFailedToLoad(
                ads.LoadAdError(0, 'domain', 'message', null),
              ),
            );
          };
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(LoadRewardedAdRequested()),
        expect: () => [
          FullScreenAdsState(status: FullScreenAdsStatus.loadingRewardedAd),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingRewardedAdFailed,
          ),
        ],
        errors: () => [isA<ads.LoadAdError>()],
      );

      test('retries loading ad based on AdsRetryPolicy', () async {
        final fakeAsync = FakeAsync();

        unawaited(
          fakeAsync.run((async) async {
            final adsRetryPolicy = AdsRetryPolicy();

            rewardedAdLoader = ({
              required String adUnitId,
              required ads.RewardedAdLoadCallback rewardedAdLoadCallback,
              required ads.AdRequest request,
            }) async {
              await Future.microtask(
                () => rewardedAdLoadCallback.onAdFailedToLoad(
                  ads.LoadAdError(0, 'domain', 'message', null),
                ),
              );
            };

            final bloc = FullScreenAdsBloc(
              adsRetryPolicy: adsRetryPolicy,
              localPlatform: localPlatform,
              interstitialAdLoader: interstitialAdLoader,
              rewardedAdLoader: rewardedAdLoader,
            )..add(LoadRewardedAdRequested());

            expect(
              (await bloc.stream.first).status,
              equals(FullScreenAdsStatus.loadingRewardedAd),
            );

            expect(
              (await bloc.stream.first).status,
              equals(FullScreenAdsStatus.loadingRewardedAdFailed),
            );

            for (var i = 1; i <= adsRetryPolicy.maxRetryCount; i++) {
              expect(
                bloc.stream,
                emitsInOrder(
                  <FullScreenAdsState>[
                    FullScreenAdsState(
                      status: FullScreenAdsStatus.loadingRewardedAd,
                    ),
                    FullScreenAdsState(
                      status: FullScreenAdsStatus.loadingRewardedAdFailed,
                    ),
                  ],
                ),
              );
              async.elapse(adsRetryPolicy.getIntervalForRetry(i));
            }
          }),
        );

        fakeAsync.flushMicrotasks();
      });
    });

    group('ShowRewardedAdRequested', () {
      final ad = FakeRewardedAd();
      final rewardItem = MockRewardItem();

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'shows ad and loads next ad',
        seed: () => FullScreenAdsState(
          status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
          rewardedAd: rewardedAd,
        ),
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(ShowRewardedAdRequested()),
        expect: () => [
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingRewardedAd,
            rewardedAd: rewardedAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingRewardedAdSucceeded,
            rewardedAd: rewardedAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingRewardedAd,
            rewardedAd: rewardedAd,
          ),
        ],
        verify: (bloc) {
          verify(
            () => rewardedAd.show(
              onUserEarnedReward: any(named: 'onUserEarnedReward'),
            ),
          ).called(1);
        },
      );

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'emits earned reward when ad is watched',
        seed: () => FullScreenAdsState(
          status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
          rewardedAd: rewardedAd,
        ),
        setUp: () {
          when(
            () => rewardedAd.show(
              onUserEarnedReward: any(named: 'onUserEarnedReward'),
            ),
          ).thenAnswer((invocation) async {
            (invocation.namedArguments[Symbol('onUserEarnedReward')]
                    as ads.OnUserEarnedRewardCallback)
                .call(ad, rewardItem);
          });
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(ShowRewardedAdRequested()),
        // Skip showingRewardedAd, showingRewardedAdSucceeded
        // and loadingRewardedAd.
        skip: 3,
        expect: () => [
          FullScreenAdsState(
            status: FullScreenAdsStatus.loadingRewardedAd,
            rewardedAd: rewardedAd,
            earnedReward: rewardItem,
          ),
        ],
      );

      test('disposes ad on ad dismissed', () async {
        final bloc = FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        )
          ..emit(
            FullScreenAdsState(
              status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
              rewardedAd: ad,
            ),
          )
          ..add(ShowRewardedAdRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<FullScreenAdsState>[
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingRewardedAd,
              rewardedAd: ad,
            ),
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingRewardedAdSucceeded,
              rewardedAd: ad,
            ),
          ]),
        );

        ad.fullScreenContentCallback!.onAdDismissedFullScreenContent!(ad);

        expect(ad.disposeCalled, isTrue);
      });

      test('disposes ad when ads fails to show', () async {
        final bloc = FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        )
          ..emit(
            FullScreenAdsState(
              status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
              rewardedAd: ad,
            ),
          )
          ..add(ShowRewardedAdRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<FullScreenAdsState>[
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingRewardedAd,
              rewardedAd: ad,
            ),
            FullScreenAdsState(
              status: FullScreenAdsStatus.showingRewardedAdSucceeded,
              rewardedAd: ad,
            ),
          ]),
        );

        final error = MockLoadAdError();
        ad.fullScreenContentCallback!.onAdFailedToShowFullScreenContent!(
          ad,
          error,
        );

        expect(ad.disposeCalled, isTrue);
      });

      blocTest<FullScreenAdsBloc, FullScreenAdsState>(
        'adds error when ad fails to show',
        seed: () => FullScreenAdsState(
          status: FullScreenAdsStatus.loadingRewardedAdSucceeded,
          rewardedAd: rewardedAd,
        ),
        setUp: () {
          when(
            () => rewardedAd.show(
              onUserEarnedReward: any(named: 'onUserEarnedReward'),
            ),
          ).thenThrow(Exception('Oops'));
        },
        build: () => FullScreenAdsBloc(
          adsRetryPolicy: AdsRetryPolicy(),
          localPlatform: localPlatform,
          interstitialAdLoader: interstitialAdLoader,
          rewardedAdLoader: rewardedAdLoader,
        ),
        act: (bloc) => bloc.add(ShowRewardedAdRequested()),
        expect: () => [
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingRewardedAd,
            rewardedAd: rewardedAd,
          ),
          FullScreenAdsState(
            status: FullScreenAdsStatus.showingRewardedAdFailed,
            rewardedAd: rewardedAd,
          ),
        ],
        errors: () => [isA<Exception>()],
      );
    });
  });
}
