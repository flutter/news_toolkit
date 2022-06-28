# Google News Template

[![google_news_template][build_status_badge]][workflow_link]
![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

## Getting Started 🚀

This project contains the following flavors:

- development
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# development
$ flutter run --flavor development --target lib/main/main_development.dart
# production
$ flutter run --flavor production --target lib/main/main_production.dart

```

_\*Google News Template works on iOS, Android._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use the internal script `tool/coverage.sh`. Make sure to install [lcov](https://github.com/linux-test-project/lcov) before.

```sh
# Generate coverage report for the app
$ ./tool/coverage.sh

# Generate coverage report for the package
$ ./tool/coverage.sh packages/app_config_repository
```

---

## Generating assets 🖼️

We're using [flutter_gen](https://pub.dev/packages/flutter_gen) to generate statically safe descriptions of image and font assets.

You need to install the `flutter_gen` tool via brew or pub, by following the [installation instruction](https://pub.dev/packages/flutter_gen/install). The configuration of the tool is stored in `pubspec.yaml`.

After that you can easily recreate the assets descriptions by calling:

```bash
$> fluttergen
```

Then to reference the asset you can call:

```dart
Assets.images.unicornVgvBlack.image(height: 120),
```

If you're adding new assets to ui library, make sure to run `fluttergen` inside the package directory as well.

## Working with Translations 🌐

This project relies on [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) and follows the [official internationalization guide for Flutter](https://flutter.dev/docs/development/accessibility-and-localization/internationalization).

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:google_news_template/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
    <array>
        <string>en</string>
        <string>es</string>
    </array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

## News Data Source 📰

The `google_news_template_api` package defines an interface for a [`NewsDataSource`](https://github.com/VGVentures/google_news_template/blob/main/api/lib/src/data/news_data_source.dart):

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

An in-memory, mock implementation of the `NewsDataSource`, called [`InMemoryNewsDataSource`](https://github.com/VGVentures/google_news_template/blob/main/api/lib/src/data/in_memory_news_data_source.dart) is used to return static news content.

### Adding a Custom News Data Source ✨

To integrate with a custom news data source, define a class that implements the `NewsDataSource` interface:

```dart
class CustomNewsDataSource implements NewsDataSource {...}
```

Then in `api/bin/server.dart` inject the `CustomNewsDataSource`:

```dart
final handler = const Pipeline()
    // Inject a custom `NewsDataSource`.
    .inject<NewsDataSource>(const CustomNewsDataSource())
    .addMiddleware(logRequests())
    .addHandler(controller.handler);
```

## Ads

### Mediation and Open Bidding

To use mediation in your mobile app, follow the links below to prepare your Google Ad Manager network and your mobile app.

- [Overview of Mediation](https://admanager.google.com/home/resources/feature-brief-app-mediation/)
- [How-to Guide](https://support.google.com/admanager/answer/7387351?hl=en&ref_topic=6373639)

To use Open Bidding in your mobile app, follow the links below.

- [Developer Documentation](https://developers.google.com/admob/flutter/mediation/get-started)
- [Overview of Open-Bidding](https://admanager.google.com/home/resources/feature-brief-open-bidding/)
- [How-to Guide](https://support.google.com/admanager/answer/7128657?hl=en&ref_topic=7512060)

## Push Notifications 📢

This template comes with [Firebase Cloud Messaging][firebase_cloud_messaging_link] pre-configured.

Out of the box, the application subscribes to supported topics corresponding to supported news categories such as `health`, `science`, `sports`, etc.

### Triggering a Notification 📬

A notification can be triggered via the [Firebase Cloud Messaging REST API][firebase_cloud_messaging_rest_api_link].

All you need is an access token which can be generated via the [Google OAuth 2.0 Playground][google_oauth2_playground_link].

Select the `https://www.googleapis.com/auth/firebase.messaging` scope under Firebase Cloud Messaging API v1 and click "Authorize APIs".

Then, sign in with the Google Account that has access to the respective Firebase project and click "Exchange authorization code for tokens".

Now you can send a message to a topic by using the following cURL:

```
curl -X POST -H "Authorization: Bearer <ACCESS_TOKEN>" -H "Content-Type: application/json" -d '{
  "message": {
    "topic" : "<TOPIC-NAME>",
    "notification": {
      "body": "This is a Firebase Cloud Messaging Topic Test Message!",
      "title": "Test Notification"
    }
  }
}' https://fcm.googleapis.com/v1/projects/<PROJECT-ID>/messages:send HTTP/1.1
```

**❗️ Important**

> Replace `<ACCESS_TOKEN>` with the access token generated from the Google OAuth 2.0 Playground, `<TOPIC-NAME>` with the desired topic name, and `<PROJECT-ID>` with the corresponding Firebase project ID.

**💡 Note**

> Ensure you are running the application on a physical device in order to receive FCM messages.

[build_status_badge]: https://github.com/VGVentures/google_news_template/actions/workflows/main.yaml/badge.svg
[coverage_badge]: coverage_badge.svg
[firebase_cloud_messaging_link]: https://firebase.google.com/docs/cloud-messaging
[firebase_cloud_messaging_rest_api_link]: https://firebase.google.com/docs/cloud-messaging/send-message#rest_3
[google_oauth2_playground_link]: https://developers.google.com/oauthplayground
[workflow_link]: https://github.com/VGVentures/google_news_template/actions/workflows/main.yaml
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
