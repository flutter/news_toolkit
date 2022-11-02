---
sidebar_position: 4
description: Learn how to configure or remove ads in your application.
---

# Ads Setup or Removal

## Configure Ads

### Google Ad Manager

- Create apps for each platform and flavor (4 apps total).
- Link the apps to the appropriate Firebase project (`Engage --> AdMob`)
- Share the app IDs with your developer team and store them within your app configuration file.

### Google AdMob

## Remove Ads

You may want to remove advertisements from your app. This section discusses how to remove the various advertisement types and their dependencies.

### Removing Banner Ads

The `static_news_data.dart` file which your app displays contains banner ads by default. As you [implement your data source](server_development/connecting_your_data_source), do not insert `AdBlocks` into the data returned from your data source. This will ensure that your app will not display `BannerAds`.

### Removing Interstitial Ads

By default, interstitial ads are displayed upon article entry by `_ArticleViewState`'s `initState` method in `lib/article/view/article_page.dart`. To remove interstitial ads entirely, you can delete

```dart
context.read<FullScreenAdsBloc>().add(const ShowInterstitialAdRequested());
```

### Removing Sticky Ads

In the template, there is a sticky ad placed in `ArticleContent` inside `lib/article/widgets/article_content.dart`. In order to remove it, delete the `StickyAd()` constructor call from the `ArticleContent` widget's `Stack.children`.

### Removing Rewarded Ads

Rewarded ads are built inside the `SubscribeWithArticleLimitModal` widget in the `lib/subscriptions/widgets/subscribe_with_article_limit_modal.dart` file.

Remove the show rewarded ad button block within the `SubscribeWithArticleLimitModal` widget to remove the rewarded ad option for premium articles:

```dart
Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg + AppSpacing.xxs,
    ),
    child: AppButton.transparentWhite(
        key: const Key(
            'subscribeWithArticleLimitModal_watchVideoButton',
        ),
        onPressed: () => context
            .read<FullScreenAdsBloc>()
            .add(const ShowRewardedAdRequested()),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Assets.icons.video.svg(),
                const SizedBox(width: AppSpacing.sm),
                Text(watchVideoButtonTitle),
            ],
        ),
    ),
),
```

### Removing Advertisement Dependencies

If you are removing advertisements from your app, it's a good idea to remove all advertisement-related dependencies from your codebase.

_Ad Source Code_

Remove the following directories and files entirely:

- `flutter_news_example/lib/ads`
- `flutter_news_example/test/ads`
- `flutter_news_example/packages/ads_consent_client`
- `flutter_news_example/packages/news_blocks_ui/lib/src/widgets/banner_ad_content.dart`
- `flutter_news_example/packages/news_blocks_ui/test/src/widgets/banner_ad_content_test.dart`
- `flutter_news_example/packages/news_blocks_ui/lib/src/banner_ad.dart`
- `flutter_news_example/packages/news_blocks_ui/test/src/banner_ad_test.dart`

Remove the noted snippets from the files below:

- `flutter_news_example/lib/app/view/app.dart`

  ```dart
  required AdsConsentClient adsConsentClient,
  ```

  ```dart
  _adsConsentClient = adsConsentClient,
  ```

  ```dart
  final AdsConsentClient _adsConsentClient;
  ```

  ```dart
  RepositoryProvider.value(value: _adsConsentClient),
  ```

  ```dart
  BlocProvider(
    create: (context) => FullScreenAdsBloc(
      interstitialAdLoader: ads.InterstitialAd.load,
      rewardedAdLoader: ads.RewardedAd.load,
      adsRetryPolicy: const AdsRetryPolicy(),
      localPlatform: const LocalPlatform(),
    )
      ..add(const LoadInterstitialAdRequested())
      ..add(const LoadRewardedAdRequested()),
    lazy: false,
  ),
  ```

- `flutter_news_example/lib/article/view/article_page.dart`
  - `HasWatchedRewardedAdListener` class
  - `HasWatchedRewardedAdListener` widget (retain the child `Scaffold` widget)
- `flutter_news_example/lib/main/main_development.dart`
  ```dart
  final adsConsentClient = AdsConsentClient();
  ```
  ```dart
  adsConsentClient: adsConsentClient,
  ```
- `flutter_news_example/lib/main/main_production.dart`
  ```dart
  final adsConsentClient = AdsConsentClient();
  ```
  ```dart
  adsConsentClient: adsConsentClient,
  ```
- `flutter_news_example/lib/onboarding/bloc/onboarding_bloc.dart`
  ```dart
  required AdsConsentClient adsConsentClient,
  ```
  ```dart
  _adsConsentClient = adsConsentClient,
  ```
  ```dart
  on<EnableAdTrackingRequested>(
    _onEnableAdTrackingRequested,
    transformer: droppable(),
  );
  ```
  ```dart
  final AdsConsentClient _adsConsentClient;
  ```
  - the `_onEnableAdTrackingRequested()` function
- `flutter_news_example/lib/onboarding/view/onboarding_page.dart`
  ```dart
  adsConsentClient: context.read<AdsConsentClient>(),
  ```
- `flutter_news_example/lib/article/widgets/article_content_item.dart`
  ```dart
  else if (newsBlock is BannerAdBlock) {
    return BannerAd(
      block: newsBlock,
      adFailedToLoadTitle: context.l10n.adLoadFailure,
    );
  }
  ```
- `flutter_news_example/lib/article/widgets/article_content_item.dart`
  ```dart
  else if (newsBlock is BannerAdBlock) {
    return BannerAd(
      block: newsBlock,
      adFailedToLoadTitle: context.l10n.adLoadFailure,
    );
  }
  ```
- `flutter_news_example/packages/news_blocks_ui/lib/news_blocks_ui.dart`
  ```dart
  export 'src/banner_ad.dart' show BannerAd;
  ```
- `flutter_news_example/packages/news_blocks_ui/lib/src/widgets/widges.dart`
  ```dart
  export 'banner_ad_content.dart';
  ```

_Pubspec Ad Depenedencies_

Remove the `google_mobile_ads` dependency from the `flutter_news_example/packages/news_blocks_ui/pubspec.yaml` file, as well as all corresponding

```dart
import  'package:google_mobile_ads/google_mobile_ads.dart'
```

statements.

Remove the `ads_consent_client` dependency from `flutter_news_example/pubspec.yaml`, as well as all `ads_consent_client` and all `ads` import statements:

```dart
import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:flutter_news_template/ads/ads.dart';
```
