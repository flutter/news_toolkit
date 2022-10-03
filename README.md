# Google News Template

## Google News Project

[Google News Project](./google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Google News Mason Template

[Google News Template](./google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Updating the App Logo

App logo image assets are displayed at both the top of the feed view and at the top of the app navigation drawer. To replace these with your custom assets, replace the following files:

- `packages/app_ui/assets/images/logo_dark.png`
- `packages/app_ui/assets/images/logo_light.png`

Change the dimensions specified in the `AppLogo` widget (`packages/app_ui/lib/src/widgets/app_logo.dart`) to match your new image dimensions.

## Subscriptions and purchases

This project supports in-app purchasing for Flutter using the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package. For the purpose of this template application, a mocked version of the`in_app_purchase` package was created called [purchase_client](https://github.com/VGVentures/google_news_template/tree/main/packages/purchase_client).

The [PurchaseClient class](https://github.com/VGVentures/google_news_template/blob/3f8d5cfd1106d3936b5d7582a82ca143c53d2535/packages/purchase_client/lib/src/purchase_client.dart#L36) implements `InAppPurchase` from the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package and utilizes the same mechanism to expose the `purchaseStream`.

```
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;
```

Mocked products are being exposed in the [products.dart](https://github.com/VGVentures/google_news_template/blob/main/packages/purchase_client/lib/src/products.dart) file.

A list of availiable subscription data featuring copy text and price information is served by Dart Frog backend. To edit the subscription data, change the `getSubscriptions()` method in your custom news data source. Make sure that the product IDs are the same for your iOS and Android purchase project, as this information will be passed to the platform-agnostic `in_app_purchase` package.

### in_app_purchase usage

To use the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package, substitute `PurchaseClient` usage in [main_development.dart](https://github.com/VGVentures/google_news_template/blob/3f8d5cfd1106d3936b5d7582a82ca143c53d2535/lib/main/main_development.dart#L80) and [main_production.dart](https://github.com/VGVentures/google_news_template/blob/3f8d5cfd1106d3936b5d7582a82ca143c53d2535/lib/main/main_production.dart#L80) with the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package implementation.

Then, follow the [Getting started](https://pub.dev/packages/in_app_purchase#getting-started) paragraph in the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package.

## Google Analytics

Google Analytics is an app measurement solution, available at no charge, that provides insight on app usage and user engagement.

This project utilizes the `firebase_analytics` package to allow tracking of user activity within the app. To use `firebase_analytics`, it is required to have a Firebase project setup correctly. For instructions on how to add Firebase to your flutter app visit [this site](https://firebase.google.com/docs/flutter/setup).

[AnalyticsRepository](https://github.com/VGVentures/google_news_template/blob/e25b4905604f29f6a2b165b7381e696f4ebc22ee/packages/analytics_repository/lib/src/analytics_repository.dart#L38) is responsible for handling event tracking and can be accessed globally within the app using `BuildContext`

```dart
class AnalyticsRepository {
  const AnalyticsRepository(FirebaseAnalytics analytics)
      : _analytics = analytics;

  final FirebaseAnalytics _analytics;

  /// Tracks the provided [AnalyticsEvent].
  Future<void> track(AnalyticsEvent event) async {
    try {
      await _analytics.logEvent(
        name: event.name,
        parameters: event.properties,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(TrackEventFailure(error), stackTrace);
    }
  }
  ...
```

## Newsletter

The current [implementation](https://github.com/VGVentures/google_news_template/blob/main/api/lib/src/api/v1/newsletter/create_subscription/create_subscription.dart) of newsletter email subscription will always return true and the response is handled in the app as a success state. Be aware that the current implementation of this feature does not store the subscriber state for a user.

```dart
/// Mixin on [Controller] which adds support for subscribing to a newsletter.
mixin CreateSubscriptionMixin on Controller {
  /// Subscribe to receive a newsletter.
  Future<Response> createSubscription(Request request) async {
    return JsonResponse.created();
  }
}
```

To fully leverage the newsletter subscription feature please add your API handling logic or an already existing email service, such as [mailchimp.](https://mailchimp.com/)

## Authentication

Currently, this project supports multiple ways of authentication such as `email`, `google`, `apple`, `twitter` and `facebook` login.

The current implementation of the login functionality can be found in [FirebaseAuthenticationClient](https://github.com/VGVentures/google_news_template/blob/e25b4905604f29f6a2b165b7381e696f4ebc22ee/packages/authentication_client/firebase_authentication_client/lib/src/firebase_authentication_client.dart#L20) inside the `packages/authentication_client` package.

The package depends on the third-party packages that expose authentication methods such as:

- `firebase_auth`
- `flutter_facebook_auth`
- `google_sign_in`
- `sign_in_with_apple`
- `twitter_login`

To enable authentication, configure each authentication method:
- For email login, enable the Email/password sign-in provider in the Firebase Console of your project. In the same section, enable Email link sign-in method. On the dynamic links page, set up a new dynamic link URL prefix (e.g. yourApplicationName.page.link) with a dynamic link URL of "/email_login".
- For Google login, enable the Google sign-in provider in the Firebase Console of your project. You might need to generate a SHA1 key for use with Android.
- For Apple login, [configure sign-in with Apple](https://firebase.google.com/docs/auth/ios/apple#configure-sign-in-with-apple) in the Apple's developer portal and [enable the Apple sign-in provider](https://firebase.google.com/docs/auth/ios/apple#enable-apple-as-a-sign-in-provider) in the Firebase Console of your project.
- For Twitter login, register an app in the Twitter developer portal and enable the Twitter sign-in provider in the Firebase Console of your project.
- For Facebook login, register an app in the Facebook developer portal and enable the Facebook sign-in provider in the Firebase Console of your project.
  
Once configured, make sure to update the Firebase config file (Google services) in your application.

For more detailed usage of these authentication methods, check [firebase.google.com](https://firebase.google.com/docs/auth/flutter/federated-auth) documentation.

## Organizing and Adjusting Blocks

As outlined in the [Working With Blocks](#working-with-blocks) section, blocks are the basic organizational components of your app's news content. Re-arranging the order of blocks allows you to control how and where your content is displayed.

Block organization typically occurs within your [backend adapters](#implementing-backend-adapters) and is then served to your app.

Reference the `article_content_item.dart` and `category_feed_item.dart` files to understand the relationship between blocks and their corresponding widgets.

Placing ads is covered in the [Updating Ads Placement](#updating-ads-placement) section, but you may want to control the placement of other widgets such as the `NewsletterBlock` which allows a user to subscribe to a mailing list. One way to arrange a block is to edit your news data source implementation's `getFeed` or `getArticle` method to insert a `NewsletterBlock` at the 15th block in the returned list, for example. This same approach can be used to introduce blocks such as the `DividerHorizontalBlock`, `TextLeadParagraphBlock`, and the `SpacerBlock` into the feed of blocks which your app receives, all of which will allow you to further customize the look and content of your app.

## Push Notifications 📢

This template comes with [Firebase Cloud Messaging][firebase_cloud_messaging_link] pre-configured. [Instructions are provided below for using OneSignal](#using-onesignal) in lieu of Firebase Cloud Messaging.

Out of the box, the application subscribes to supported topics corresponding to supported news categories such as `health`, `science`, `sports`, etc.

### Triggering a Notification 📬

A notification can be triggered via the [Firebase Cloud Messaging REST API](https://firebase.google.com/docs/reference/fcm/rest).

All you need is an access token which can be generated via the [Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground/).

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

### Using OneSignal

Follow OneSignal's guide for [setting up the OneSignal Flutter SDK](https://documentation.onesignal.com/docs/flutter-sdk-setup). Make sure to:

- Ensure all requirements for integration listed in the OneSignal documentation are met.
- Add the OneSignal Flutter SDK dependency.
- Add an iOS service extension in Xcode.
- Enable `push capability` in Xcode.
- Setup OneSignal for Android in the codebase.
- Initialize OneSignal in the notifications client package.
- Replace FCM references in the codebase with the corresponding OneSignal infrastructure:
	- In `lib/main/bootstap/bootstrap.dart` replace `FirebaseMessaging` with `OneSignal` and the `FireBaseMessaging.instance` with a `OneSignal.shared` instance.
	- In the `main.dart` file for each of your flavors, assign `notificationsClient` to an instance of `OneSignalNotificationsClient`
- Run the app and send test notifications through OneSignal.
	- *Note: iOS push notifications only work if tested on a physical device*.

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
