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
