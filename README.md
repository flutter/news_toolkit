# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Updating Ads Placement

### Updating Banner Ads

In the sample Google News Project, banner ads are introduced as [blocks](#working-with-blocks) served from static news data. The static news data contains instances of `BannerAdBlock` which the app renders as ads inside the feed and articles.

To introduce banner ads into your app, you can either:

 1. Insert them locally at the client level or
 2. Insert them into the data served by your [data source](#implementing-an-api-data-source).

*Inserting Banner Ads Locally*

To insert banner ads locally, add `BannerAdBlocks` with your desired size into any block feed by adjusting the state emitted by the `ArticleBloc` and `FeedBloc`, respectively. 

For example, to insert banner ads into the category feed view, edit the `FeedBloc._onFeedRequested()` method to insert a `BannerAdBlock` every 15 blocks, and subsequently emit the updated feed.

If you want banner ads to appear outside of a feed view, you can call the `BannerAd` widget constructor with a `BannerAdBlock` at your desired location in the widget tree.

*Inserting Banner Ads at the Data Source*

Inserting banner ads into content served by your backend API is the same as local insertion, except you can only insert a `BannerAdBlock` into block feeds (such as the article or category feed) and you are unable to prompt a call to build a `BannerAd` elsewhere in the app out-of-the-box.

To insert a banner ad on the server, change the behavior of your [custom data source](#implementing-an-api-data-source). Methods such as `getFeed()` and `getArticle()` should insert a `BannerAdBlock` into the blocks returned from the server at your desired positions.

Be sure to update the `totalBlocks` metadata returned by the server to reflect the total number of blocks served to the client. This ensures that the client renders all content properly.

### Updating Interstitial Ads

Interstitial ads are full-screen ads that appear between content. By default, interstitial ads are displayed upon article entry by `_ArticleViewState`'s `initState` method in `lib/article/view/article_page.dart`. To remove interstitial ads entirely, you can delete

```dart
context.read<FullScreenAdsBloc>().add(const ShowInterstitialAdRequested());
```

Alternatively, you can move that line to a location to execute after your desired event (e.g. upon article close). 

### Updating Sticky Ads

Sticky ads are small dismissible ads that are anchored to the bottom of the screen. Sticky ads are built by the `StickyAd` widget. In the template, there is a sticky ad placed in `ArticleContent` inside `lib/article/widgets/article_content.dart`. Move the `StickyAd()` constructor if you want to change which screen sticky ads are shown on.

### Updating Rewarded Ads

Rewarded ads allow the user to view an advertisement to enable a desired action. In the template, unsubscribed users have the opportunity to watch a rewarded ad after viewing four articles, which unlocks the ability to view an additional article. Rewarded ads are built inside the `SubscribeWithArticleLimitModal` widget in the `lib/subscriptions/widgets/subscribe_with_article_limit_modal.dart` file.

The line
```dart
context.read<FullScreenAdsBloc>().add(const ShowRewardedAdRequested())
```
is executed on clicking the `Watch a video to view this article` button on the modal bottom sheet. Move the above line to trigger a rewarded ad at your desired position inside the app. Make sure to create a `HasWatchedRewardedAdListener` similar to the one found in `lib/article/view/article_page.dart` to display the desired content after the user has watched the rewarded ad.
