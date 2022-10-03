# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Updating App Colors

The colors used throughout your app are specified in the `app_colors.dart` file found in `packages/app_ui/lib/src/colors`. Add custom colors to this file and reference them as an attribute of the `AppColors` class inside your app (e.g. `AppColors.orange`). The role of colors within your app can be specified as either theme information or as an inline color.

### Updating Theme Colors

Some colors are assigned to themes, which allow colors to be shared throughout your app based on their intended role in the user interface. For additional information on specifying theme colors, reference the Flutter [Use Themes to Share Colors and Font Styles](https://docs.flutter.dev/cookbook/design/themes) cookbook.

App themes are laid out in the `app_theme.dart` file inside the `packages/app_ui/lib/src/theme` folder. For example, the widget-specific theme `_appBarTheme` allow you to specify the colors and theme information for your [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html).

### Updating Inline Colors

Not all of your desired color assignments can be specified by changing the app's theme data. You may want to use a color only on certain instances of a widget or specify colors with more granularity than the theme information supports. There are several existing inline color specifications in your app:

*Specifying Button Colors*

The colors of an app button are specified by the named constructors laid out in `packages/app_ui/lib/src/widgets/app_button.dart`. To specify new button colors, create a new color constructor. For example, to create an orange app button create the constructor

```dart
const AppButton.orange({
  Key? key,
  VoidCallback? onPressed,
  double? elevation,
  TextStyle? textStyle,
  required Widget child,
}) : this._(
        key: key,
        onPressed: onPressed,
        buttonColor: AppColors.orange,
        child: child,
        foregroundColor: AppColors.white,
        elevation: elevation,
        textStyle: textStyle,
     );
```

You can then call the new `AppButton.orange` constructor in your app wherever you want to add an orange button, or replace an existing constructor call such as `AppButton.redWine` with your new constructor to update the button color.

*Specifying TabBar Colors*

The `TabBarTheme` specified in `app_theme.dart` does not provide a `backgroundColor` property. To specify a specific color for the `CategoriesTabBar` rendered below the `AppBar`, edit `CategoriesTabBar`'s `build()` method inside `lib/categories/widgets/categories_tab_bar.dart` to place the `TabBar` widget inside a `ColoredBox`:

```dart
return ColoredBox(
  color: AppColors.organge,
  child: TabBar(
    controller: controller,
    isScrollable: true,
    tabs: tabs,
  ),
);
```

Other widgets with in-line specified colors include:
- `PostContentPremiumCategory`
- `SlideshowCategory`
- `PostContentCategory`
- `MagicLinkPromptSubtitle`
- `ManageSubscriptionView`
- `AppTextField`
- `ArticleIntroduction`

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
is executed upon tapping the `Watch a video to view this article` button on the modal bottom sheet. Move the above line to trigger a rewarded ad at your desired position inside the app. Make sure to create a `HasWatchedRewardedAdListener` similar to the one found in `lib/article/view/article_page.dart` to display the desired content after the user has watched the rewarded ad.

## Working with Blocks

### What are Blocks?

*Note: `blocks` are distinct from [`blocs`](https://bloclibrary.dev/#/), which are also used in this application.*

Blocks are the data format used by Google News Template to ensure that a variety of news content can be displayed in a consistent manner. The client application expects to receive data from the server in a block-based format. For example, the `Article` model class contains a list of blocks. 

These blocks contain the data which the app requires to render a corresponding widget.

As described in [Implementing an API Data Source](#implementing-an-api-data-source), your backend is responsible for transforming data from your CMS into the block-based format expected by the app. The app will then display the data according to its own internal rendering rules.

This diagram provides an overview of how blocks are used in the example template application:

![block-diagram](https://user-images.githubusercontent.com/61138206/192628148-e1af73e4-4b81-4dff-8926-c411294b4b86.png)

In this example, data from the CMS is transformed by the [Dart Frog server](#implementing-an-api-data-source) into a `PostLargeBlock` to respond to a request from the app. The `CategoryFeed` widget receives the data from the app's `FeedBloc` and gives the `PostLargeBlock` to a newly-constructed `PostLarge` widget to dictate what data the widget should render on-screen.

### Using Blocks

You can view the relationship between blocks and their corresponding widgets in `lib/article/widgets/article_content_item.dart` and `lib/article/widgets/category_feed_item.dart`. 

`ArticleContentItem` specifies how a block will be rendered inside an article view, while `CategoryFeedItem` specifies how a block will be rendered inside the feed view. Both classes also provide callbacks to widgets which exhibit behavior on an interaction, such as a press or tap by the user. Look through those files to review the available blocks that can feed into your app out-of-the-box.

Note that if your CMS returns content in an HTML format, you may want to segment your articles and provide it to the app inside an `HtmlBlock`, which will render the content inside an [`Html`](https://pub.dev/packages/flutter_html) widget. Styling for HTML content is covered in the [Updating the App Typography](#updating-the-app-typography) section of this document.

Also note that many block files have an additional `.g` file in the same folder which shares its name. For example, there is both `banner_ad_block.dart` and `banner_ad_block.g.dart`. The `.g` file contains generated code to support functionality such as JSON serialization. When you change any file with associated generated code, [make sure code generation runs and is kept up-to-date with your source code content](https://docs.flutter.dev/development/data-and-backend/json#running-the-code-generation-utility).

## Implementing an API Data Source

The template's [Dart Frog](https://dartfrog.vgv.dev) API acts as an intermediary between your CMS and the client application, organizing your content into the [blocks](#working-with-blocks) that form the basis of content organization within the app.

If you don't intend to write custom code to support the necessary block-organized endpoints from your CMS, you should create and deploy an API which uses the `NewsDataSource` interface to collect and transform data.

Your implementation of the `NewsDataSource` will be called by the route handlers laid out in the `api/routes` directory. The data source will then request data from your CMS and organize it into the block-based data expected by the client before returning it to the route handler to be served to your client application. For more information about the structure and capabilities of the Dart Frog server that will be utilizing your data source, please consult the [Dart Frog documentation](https://dartfrog.vgv.dev/docs/category/basics).

The `NewsDataSource` class found in `api/lib/src/data/news_data_source.dart` provides an interface which your data source must implement. Feel free to remove methods which provide data that you don't intend to use in the client app, or to add methods to provide data for functionality which you intend on adding to your app.

### Creating a New Data Source

Begin by defining a new class which implements `NewsDataSource`. 

```dart
class YourCustomDataSource implements NewsDataSource
```

Your data source should have a means of interacting with your CMS as a field such as an [HTTP](https://pub.dev/packages/http) or [Dio](https://pub.dev/packages/dio) client, and you may want to create separate named constructors if you have different CMS URLs for different flavors, such as development and production.

### Implementing Backend Adapters

After creating your data source class, you should implement the methods defined in `NewsDataSource`:

```dart
/// {@template news_data_source}
/// An interface for a news content data source.
/// {@endtemplate}
abstract class NewsDataSource {
  /// {@macro news_data_source}
  const NewsDataSource();
	
  /// Returns a news [Article] for the provided article [id].
  ///
  /// In addition, the contents can be paginated by supplying
  /// [limit] and [offset].
  ///
  /// * [limit] - The number of content blocks to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<Article?> getArticle({
    required String id,
	int limit = 20,
	int offset = 0,
  });

  /// Returns a list of current popular topics.
  Future<List<String>> getPopularTopics();

  /// Returns a list of current relevant topics
  /// based on the provided [term].
  Future<List<String>> getRelevantTopics({required String term});

  /// Returns a list of current popular article blocks.
  Future<List<NewsBlock>> getPopularArticles();

  /// Returns a list of relevant article blocks
  /// based on the provided [term].
  Future<List<NewsBlock>> getRelevantArticles({required String term});

  /// Returns [RelatedArticles] for the provided article [id].
  ///
  /// In addition, the contents can be paginated by supplying
  /// [limit] and [offset].
  ///
  /// * [limit] - The number of content blocks to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<RelatedArticles> getRelatedArticles({
	required String id,
	int limit = 20,
	int offset = 0,
  });

  /// Returns a news [Feed] for the provided [category].
  /// By default [Category.top] is used.
  ///
  /// In addition, the feed can be paginated by supplying
  /// [limit] and [offset].
  ///
  /// * [limit] - The number of results to return.
  /// * [offset] - The (zero-based) offset of the first item
  /// in the collection to return.
  Future<Feed> getFeed({
	Category category = Category.top,
	int limit = 20,
	int offset = 0,
  });
	
  /// Returns a list of all available news categories.
  Future<List<Category>> getCategories();
}
``` 

For example, an implementation of `getArticle()` might look like:
```dart
@override
Future<Article?> getArticle({
  required String id,
  int limit = 20,
  int offset = 0,
  bool preview = false,
}) async {
  final uri = Uri.parse('$YOUR_CMS_BASE_URL/posts/$id');
  final response = await httpClient.get(uri);

  if (response.statusCode != HttpStatus.ok) {
    throw YourAppApiFailureException(
      body: response.body,
      statusCode: response.statusCode,
    );
  }

  final responseJson = response.jsonMap();
  if (responseJson.isNotFound) return null;

  final post = Post.fromJson(responseJson);
  final article = post.toArticle();

  return article;
}
```

The above example references a class not included in the template, `Post`: 

```dart
class Post {
  const Post({
    required this.id,
    required this.date,
    required this.link,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.category,
  });
  
  final int id;
  final DateTime date;
  final String link;
  final String title;
  final String content;
  final Author author;
  final String image;
  final PostCategory category;
}
```

Since your CMS presumably doesn't respond with data in the block-based format used by the `Article` class, you may want to define classes like `Post` which mirror the data types and formats which your CMS returns. 

You can use a package like [json_serializable](https://pub.dev/packages/json_serializable) to generate code to create a `Post` object from the JSON returned from your CMS (see [JSON and serialization - Flutter Documentation](https://docs.flutter.dev/development/data-and-backend/json)). 

You can then [add an extension method](https://dart.dev/guides/language/extension-methods) such as `toArticle()` on your `Post` class which uses the relevant data from the `Post` object and to create and return an `Article` object which will be served to your client app.

This structure of `JSON -> Intermediary Object -> API Model` can be repeated in implementing any data source method which receives data from your CMS that differs from what the method is expected to return.

### Using Your Data Source Within the API

After creating your data source, inject it into your API route handler through the [Dart Frog middleware](https://dartfrog.vgv.dev/docs/basics/dependency-injection).

First instantiate your data source:

`final yourCustomDataSource = YourCustomDataSource();`

Then inject it through the middleware as a `NewsDataSource`:

`handler.use(provider<NewsDataSource>((_) =>  yourCustomDataSource));`

As the template already contains a `NewsDataSource` dependency injection, you can simply instantiate your data source and then replace `inMemoryNewsDataSource` with `yourCustomDataSource`.

## Updating the Privacy Policy & Terms of Service

Terms of service and privacy policy page information can be accessed by your users from the `UserProfilePage` or the `LoginWithEmailForm`.

You will want to replace the placeholder text displayed in the `TermsOfServiceModal` and `TermsOfServicePage` widgets with your app's privacy policy and terms of service. This can be accomplished by editing the `TermsOfServiceBody` widget found in `lib/terms_of_service/widgets/terms_of_service_body.dart`. 

You can either:

- Display `WebView` widgets which link to your privacy policy and terms of service documents hosted on the web (*recommended*) or
- Pass your documents as Strings to `Text` widgets inside the `TermsOfServiceBody` widget.

In order to use the `WebView` solution, replace the `SingleChildScrollView` widget in `TermsOfServiceBody` with one or more `WebView` widgets which link to your documents. Be sure to specify `gestureRecognizers` for `WebViews` so that they are scrollable.

## Updating the App Typography

### Fonts

For general details regarding font customization, reference Flutter's [Use a Custom Font](https://docs.flutter.dev/cookbook/design/fonts) documentation. 

To change the fonts used in your app, first add your font assets inside `packages/app_ui/assets/fonts`, then list the added fonts under the `fonts` section of `packages/app_ui/pubspec.yaml`.

You can specify which fonts you want used in different elements of your app in the `packages/app_ui/lib/src/typography/app_text_styles.dart` file.

You can specify the fonts used in your app by changing the `fontFamily` value at the following locations inside the `app_text_styles.dart` file to match the name of your desired font family:

- `UITextStyle._baseTextStyle`
	- Specifies the default font used in UI elements.
- `ContentTextStyle._baseTextStyle`
	- Specifies the default font used in news content.
- `button`
	- Specifies the font used in buttons.
- `caption`
	- Specifies the font used in your caption text.
- `overline`
	- Specifies the font used in overline text elements such as category labels.
- `labelSmall`
	- Specifies the font used in label text (*not referenced in the template out-of-the-box*).

### Text Appearance

To customize your app's typography further, you can add and edit various `TextStyle` values, such as `fontWeight`, `fontSize`, and others in the `packages/app_ui/lib/src/typography/app_text_styles.dart` file. 
The correspondence between selected `TextStyles` and visual elements in the app is illustrated below.

For styling text contained in `HtmlBlocks`, you can edit the `style` map in `packages/news_blocks_ui/lib/src/html.dart` to associate HTML selectors with the `TextStyle` you want to be utilized when the HTML is rendered.

### Illustrating Where App `TextStyles` are Used

<img src="https://user-images.githubusercontent.com/61138206/191820826-7ef6c873-94ee-49e8-bcd6-25e35421c055.png">

## Updating the App Launcher Icon

You can use the [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) package to streamline adding your new app launcher icon.

Alternatively, you may want to manually update your app's launcher icon. Flutter's documentation contains information on how to accomplish this for both [iOS](https://docs.flutter.dev/deployment/ios#add-an-app-icon) and [Android](https://docs.flutter.dev/deployment/android#adding-a-launcher-icon).

## Updating the App Splash Screen

Flutter's [Adding a Splash Screen to Your Mobile App](https://docs.flutter.dev/development/ui/advanced/splash-screen) documentation provides the most up-to-date and in-depth guidance on customizing the splash screen in your mobile app.

### Android Splash Screen

Within the `android/app/src/main/res` folder, replace `launch_image.png` inside the 

 - `mipmap-mdpi` 
 - `mipmap-hdpi` 
 - `mipmap-xhdpi` 
 - `mipmap-xxhdpi`
 
folders with the image asset you want featured on your Android splash screen. The `launch_image.png` you provide inside the `mipmap` folders should have an appropriate size for that folder.

The background color of your splash screen can be changed by editing the hex code value with `name="splash_background"` in `android/app/src/main/res/values/colors.xml`.

### iOS Splash Screen

You should configure your iOS splash screen using an Xcode storyboard. To begin, add your splash screen image assets named 

 - `LaunchImage.png` 
 - `LaunchImage@2x.png`  
 - `LaunchImage@3x.png`

 with sizes corresponding to the filename inside the  `ios/Runner/Assets.xcassets/LaunchImage.imageset` folder. 

Open your project's `ios` folder in Xcode and open `Runner/LaunchScreen.storyboard` in the editor. Specify your desired splash screen image and background by selecting those elements and editing their properties in the Xcode inspectors window. Feel free to further edit the splash screen properties in the Xcode inspectors window to customize the exact look of your splash screen.