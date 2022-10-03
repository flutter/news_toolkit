# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

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
