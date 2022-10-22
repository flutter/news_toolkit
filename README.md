# Google News Template

The Google Flutter team and Google News initiative have co-sponsored the development of a news application template. Our goal is to help news publishers to build apps and monetize more easily than ever.

This template aims to **reduce typical news app development time by 80%.**

The Flutter news app template:
- contains common news app UI workflows and core features built in Flutter and Firebase
- implements best practices for news apps based on [Google News Initiative research](https://newsinitiative.withgoogle.com/info/assets/static/docs/nci/nci-playbook-en.pdf)
- allows publishers to monetize immediately with pre-built Google Ads and subscription services

To preview the [available features](#available-features) in this app, run the example app using this template in the [Google News Project](https://github.com/flutter/news_template/blob/main/google_news_project/README.md) folder by following the setup steps in the project's README.

## Google News Mason Template

[Google News Template](https://github.com/flutter/news_template/blob/main/google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Available Features

The Google News Template was crafted to support a variety of news-oriented features. This feature list and product design was generated from real publisher feedback and direction. Although this list is not all-encompassing, it offers a feature-rich starting point for your own unique news application:

- Ready-to-go core services (e.g. Firebase, [Google Analytics](#google-analytics), Google Ads, FCM or OneSignal, Cloud Run, etc. )
	- Note that these services can be changed to fit your unique requirements, but would require a development effort. 
 
- [User Authentication](#authentication) (Apple/Google/Email/Facebook/Twitter)
- [Push Notifications](#push-notifications) (FCM or OneSignal)
- App Tracking
- Content Feed
- Article Pages
- In-Line Images
- Image Slideshow
- Video Player
- Search
- [Subscription & Purchases](#subscriptions-and-purchases)
- [Newsletter Subscription](#newsletter)
- [Ads](#ads) (banner ads, interstitial ads, sticky ads, rewarded ads)
- Commenting UI
- Pull to Refresh

# Development Roadmap

Below is an example project roadmap that can be leveraged to implement this template for your very own Flutter application. Please use this as a guide for your development efforts and deviate where necessary.

### Initial Configuration

- Follow the configuration steps outlined in [this section](#configuration) before starting your project. These steps will ensure your project is set-up appropriately and will supply your team with the necessary keys required for your application.

### Code Generation

- After completing your pre-project setup and configuration, [generate your codebase](#generating-your-codebase-with-mason) using [mason](https://pub.dev/packages/mason).
- The [Google News Template](https://github.com/kaiceyd/news_template/blob/patch-1/google_news_template/README.md) supports the following decision points:
	- Application name (*e.g. News Template*)
	- Application package name (*e.g. news_template*)
	- Desired Flutter version
	- Application bundle identifier (*e.g. com.news.template*)
	- Code Owners
	- Flavors, where each flavor includes a different:
		- Application suffix (appended to the application bundle identifier for a given flavor)
		- Deep link domain (used to navigate from the app from email login link, configured from the Firebase Console)
		- Twitter configuration (API key and API secret; used to login with Twitter)
		- Facebook configuration (App ID, client token and display name; used to login with Facebook)
		- Google Ad Manager or Admob configuration (App ID for iOS and Android; used to display ads)

### Google Play Store:

- [Set up API access](https://play.google.com/console/u/0/developers/6749221870414263141/api-access) 

### Translations

This project relies on [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html) and follows the [official internationalization guide for Flutter](https://flutter.dev/docs/development/accessibility-and-localization/internationalization). If you would like to support a different language (or multiple languages) in your app, please review [this section](#working-with-translations) for instruction.

### Theming & Branding

- Update your app's [splash screen](#updating-the-app-splash-screen).
- Update your app's [launcher icons](#updating-the-app-launcher-icon).
	- If you'd like to support [adaptive icons for Android](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive), ensure you have background and foreground assets. 

- Update the [app logo in the top navigation bar](#updating-the-app-logo).
- Update the app's [colors](#updating-app-colors) via the app's [theme](#updating-theme-colors) and [in-line color references](#updating-inline-colors).
- Update the app's [typography](#updating-the-app-typography).
- Update the app's [Privacy Policy and/or Terms of Service](#updating-the-privacy-policy-&-terms-of-service) in the app's settings and authentication screens.

### Data Source & Feature Implementation

- Once the app is starting to reflect your brand, you'll want to [implement your API datasource](#implementing-an-api-data-source).
- Next, you'll need to [set-up backend adapters](#implementing-backend-adapters) for each of the following endpoints:
	- getArticle
	- getFeed
	- getCategories
	- getTrendingStory
	- getSubscriptions
	- getRelatedArticles
	- getReleventTopics (search)
	- getReleventArticles (search)
	- getPopularArticles (search)
	- getPopularTopics (search)
	- subscribeToNewsletter

- You'll also want to [implement push notifications](#push-notifications) using either FCM or OneSignal and update the UI to support the categories of notifications that you'd like to enable. 
- [Organize and adjust your blocks](#organizing-and-adjusting-blocks) in your content feed and article pages to create a customized look and feel for your app.
- Finally, [make any adjustments to the ads logic](#updating-ads-placement) to match your organization's requirements.

### API Deployment & Versioning

- After ensuring your dev and production api have been successfully [deployed on Cloud Run](#google-cloud-api-deployments), you'll want to [release a new build version to your app stores](#version-bump).

### Project Wrap-Up

- Remove [test mode configuration](https://developers.google.com/admob/flutter/test-ads) for ads before submitting your app for review. 
	- Note that this should be done as close to submission as possible to avoid unnecessary costs for ads engagement in your test apps.
- Finalize metadata and required fields for app store submission and review. 
	- Google Play Store: `Policy --> App Content`
	- Apple App Store Connect: `General --> App Privacy --> Data Types`
- Submit your apps for review.
- Once approved, release your apps!

# Configuration

## Pre-Project Setup

### Github:

- Create repository within the ‘Github Organization’ to enable:
	- The following recommended branch protection rules:
		- Require a pull request before merging (require approvals, dismiss stale pull request approvals when new commits are pushed, require review from Code Owners).
		- Require status checks to pass before merging (require branches to be up to date before merging).
		- Require linear history.
	- [Slack Integration](https://github.com/integrations/slack/blob/master/README.md) (recommended)
	- [Auto-deletion](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches) and [auto-merge](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository) for branches
	- Draft PRs
- Grant Admin access to at least one developer to enable secrets creation.

### Facebook Authentication:

- Create an app in the [Facebook developer portal](https://developers.facebook.com/apps/).
- In the same portal, enable the Facebook Login product (`Products -> Facebook Login`).
- Go to `Roles -> Roles` and add your developer team so the team can customize the agpp configuration for Android and iOS.
- In Facebook, go to `Settings -> Advanced` and enable "App authentication, Native or desktop app?"
- After setting up your [Firebase project](#firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Facebook` to set up Facebook authentication method. Fill in the app ID and secret from the created Facebook app and share these secrets with your developer team.
- Use "OAuth redirect URI" from Firebase to set "Valid Oauth Redirect URIs" in the Facebook portal.

### Twitter Authentication:

- Create a project and app in the [Twitter developer portal](https://developer.twitter.com/) - both can have the same name like "Google News Template". Save the API key and secret when creating an app and share these secrets with your developer team.
- Enable OAuth 2.0 authentication by setting "yourapp://" as the callback URI and "Native app" as the type of the app.
- In [Twitter products](https://developer.twitter.com/en/portal/products), make sure to have the Twitter API v2 enabled with "Elevated" access - otherwise Twitter authentication is not going to work. 
	- You may need to fill out a form to apply for “Elevated” access.
- If possible, add your full team as developers of the Twitter app.
- After setting up your [Firebase project](#firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter` to set up Twitter authentication method. Fill in the app ID and secret from the created Twitter app and share these secrets with your developer team.

### [Firebase](https://github.com/flutter/news_template/blob/main/google_news_template/README.md#recommended-firebase-configuration):

- It is recommended to define at least two application environments: development and production. Each environment defines a different configuration of deep links, ads and authentication along with a different entry point to the application (e.g. `main_development.dart`).

- When generating the template, choose "development production" as a list of desired application flavors. Choose "dev" as the application suffix for the development flavor.

- In Firebase, configure two separate Firebase projects for the development and production flavor. You may do this [from the Firebase console](https://console.firebase.google.com/u/0/) or using the [firebase-tools CLI tool](https://github.com/firebase/firebase-tools) and the `firebase projects:create` command. In each Firebase project, create an Android and iOS app with appropriate package names. Make sure that development apps include the "dev" suffix. You may also do this using the `firebase apps:create` command.

- Once configured, go to each Firebase project's settings and export the Google Services file for all apps. In the generated template, replace the content of all generated Google Services using exported configurations. 
- Ensure the developer team has admin access.
- Note the app IDs for your developer team.
	- Note that the app IDs can be specified when generating your codebase in mason.
- Set-up Firebase authentication for supported sign-in platforms (Apple/Google/Email/Facebook/Twitter/etc.):
	- For email login, enable the Email/password sign-in provider in the Firebase Console of your project. In the same section, enable Email link sign-in method. On the dynamic links page, set up a new dynamic link URL prefix (e.g. yourApplicationName.page.link) with a dynamic link URL of "/email_login".
	- For Google login, enable the Google sign-in provider in the Firebase Console of your project. You might need to generate a SHA1 key for use with Android.
	- For Apple login, [configure sign-in with Apple](https://firebase.google.com/docs/auth/ios/apple#configure-sign-in-with-apple) in the Apple's developer portal and [enable the Apple sign-in provider](https://firebase.google.com/docs/auth/ios/apple#enable-apple-as-a-sign-in-provider) in the Firebase Console of your project.
	- For Twitter login, register an app in the Twitter developer portal and enable the Twitter sign-in provider in the Firebase Console of your project.
	- For Facebook login, register an app in the Facebook developer portal and enable the Facebook sign-in provider in the Firebase Console of your project.
    
### [Google Ad Manager](https://support.google.com/admanager/answer/1656921) or [Admob](https://support.google.com/admob/answer/7356431):

- Create apps for each platform and flavor (4 apps total).
- Link the apps to the appropriate Firebase project (`Engage --> AdMob`)
- Share the app IDs with your developer team and store them within your app configuration file.
    
### FCM or OneSignal:

- Share the developer and production app IDs with the development team and store them within your app configuration file.

### App Store:

- Create an Apple Developer team/organization.
- Ensure your project team has the appropriate access and roles in the `Users and Access` tab.
- Create a developer and production app.
- Configure the Privacy Policy and Terms of Use (EULA) in the `App Privacy --> Privacy Policy` section.
- Configure the "Localizable Information" and "General Information" in the `App Information` section.
- Create first release to be able to setup subscriptions.
- [Set-up the subscription package](https://appstoreconnect.apple.com/) in the developer and production apps (`Features -->In-App Purchases` & `Features -->Subscriptions`).

### Google Play Store:

- Create a Google Play Developer Console team/organization. 
- Ensure your project team has the appropriate access and roles. 
- Create a developer and production app.
- Configure app information in `Store presence --> Main store listing`.
- Configure the store settings (`Store presence --> Store settings`).
- [Set up the subscription product](https://play.google.com/console/u/0/developers/6749221870414263141/app-list) (`Products --> Subscriptions`).

## After Code Generation

### Codemagic:

- Configure the ‘TODO’ fields in the codemagic.yaml file located in your repository.
- Create the [App Store API Key](https://docs.codemagic.io/yaml-code-signing/signing-ios/#creating-the-app-store-connect-api-key) and add this to your Codemagic account.
- [Generate and upload a Keystore](https://docs.codemagic.io/yaml-code-signing/signing-android/#generating-a-keystore).
- Configure the prod_emails and tst_emails in the codemagic.yaml file located in your repository.
- Set up the [GPLAY_KEY](https://docs.codemagic.io/knowledge-base/google-services-authentication/) in Codemagic.
- Encrypt the GPLAY_KEY in Codemagic .
- Set-up the [GoogleApiService account connection](https://docs.codemagic.io/knowledge-base/google-services-authentication/) in Codemagic

### Google Cloud API Deployments:

- Set-up a [Google Cloud   
   account](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
   to host your API.
	- Enable Billing.
- Set-up an [Github Action Service account](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).
- Configure [API authentication](https://cloud.google.com/docs/authentication#:~:text=the%20section%20below.-,Authentication%20strategies,public%20data%20using%20API%20keys.)
   and [user authentication for your   
   API](https://cloud.google.com/run/docs/authenticating/end-users#cicp-firebase-auth)
   (optional).
   
# Implementation Details

## Generating Your Codebase With Mason

[Mason](https://pub.dev/packages/mason) is a command line application which allows you to generate a customized codebase based on your specifications. To generate your app using Mason, follow the steps below.

### Activate Mason

```sh
dart pub global activate mason_cli
```

### Add the Google News Template Brick

When using user/password authentication:

```sh
mason add google_news_template -g --git-url https://github.com/flutter/news_template --git-path google_news_template
```

When using ssh authentication:

```sh
mason add google_news_template -g --git-url git@github.com:flutter/news_template.git --git-path google_news_template
```

### Generate

```sh
mason make google_news_template -c template.json
```

For additional usage information and information about how to create custom templates refer to the [mason documentation](https://github.com/felangel/mason).

## Working with Translations

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

### Text Directionality

Flutter automatically supports right-to-left languages when the user changes their language settings. No additional configuration or code is required to support text directionality as referenced in the [Flutter internationalization guide](https://docs.flutter.dev/development/accessibility-and-localization/internationalization) in your app.

## Authentication

Currently, this project supports multiple ways of authentication such as `email`, `google`, `apple`, `twitter` and `facebook` login.

The current implementation of the login functionality can be found in [FirebaseAuthenticationClient](https://github.com/flutter/news_template/tree/main/google_news_project/packages/authentication_client/firebase_authentication_client/lib/src/firebase_authentication_client.dart#L20) inside the `packages/authentication_client` package.

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

## Google Analytics

Google Analytics is an app measurement solution, available at no charge, that provides insight on app usage and user engagement.

This project utilizes the `firebase_analytics` package to allow tracking of user activity within the app. To use `firebase_analytics`, it is required to have a Firebase project setup correctly. For instructions on how to add Firebase to your flutter app visit [this site](https://firebase.google.com/docs/flutter/setup).

[AnalyticsRepository](https://github.com/flutter/news_template/tree/main/google_news_project/packages/analytics_repository/lib/src/analytics_repository.dart#L38) is responsible for handling event tracking and can be accessed globally within the app using `BuildContext`

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

## Updating the App Launcher Icon

You can use the [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons) package to streamline adding your new app launcher icon.

Alternatively, you may want to manually update your app's launcher icon. Flutter's documentation contains information on how to accomplish this for both [iOS](https://docs.flutter.dev/deployment/ios#add-an-app-icon) and [Android](https://docs.flutter.dev/deployment/android#adding-a-launcher-icon).

## Updating the App Logo

App logo image assets are displayed at both the top of the feed view and at the top of the app navigation drawer. To replace these with your custom assets, replace the following files:

- `packages/app_ui/assets/images/logo_dark.png`
- `packages/app_ui/assets/images/logo_light.png`

Change the dimensions specified in the `AppLogo` widget (`packages/app_ui/lib/src/widgets/app_logo.dart`) to match your new image dimensions.

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

## Updating the Privacy Policy & Terms of Service

Terms of service and privacy policy page information can be accessed by your users from the `UserProfilePage` or the `LoginWithEmailForm`.

You will want to replace the placeholder text displayed in the `TermsOfServiceModal` and `TermsOfServicePage` widgets with your app's privacy policy and terms of service. This can be accomplished by editing the `TermsOfServiceBody` widget found in `lib/terms_of_service/widgets/terms_of_service_body.dart`. 

You can either:

- Display `WebView` widgets which link to your privacy policy and terms of service documents hosted on the web (*recommended*) or
- Pass your documents as Strings to `Text` widgets inside the `TermsOfServiceBody` widget.

In order to use the `WebView` solution, replace the `SingleChildScrollView` widget in `TermsOfServiceBody` with one or more `WebView` widgets which link to your documents. Be sure to specify `gestureRecognizers` for `WebViews` so that they are scrollable.

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

## Organizing and Adjusting Blocks

As outlined in the [Working With Blocks](#working-with-blocks) section, blocks are the basic organizational components of your app's news content. Re-arranging the order of blocks allows you to control how and where your content is displayed.

Block organization typically occurs within your [backend adapters](#implementing-backend-adapters) and is then served to your app.

Reference the `article_content_item.dart` and `category_feed_item.dart` files to understand the relationship between blocks and their corresponding widgets.

Placing ads is covered in the [Updating Ads Placement](#updating-ads-placement) section, but you may want to control the placement of other widgets such as the `NewsletterBlock` which allows a user to subscribe to a mailing list. One way to arrange a block is to edit your news data source implementation's `getFeed` or `getArticle` method to insert a `NewsletterBlock` at the 15th block in the returned list, for example. This same approach can be used to introduce blocks such as the `DividerHorizontalBlock`, `TextLeadParagraphBlock`, and the `SpacerBlock` into the feed of blocks which your app receives, all of which will allow you to further customize the look and content of your app.

## Ads

This project uses [Google Mobile Ads Flutter plugin](https://pub.dev/packages/google_mobile_ads), which enables publishers to monetize this Flutter app using the Google Mobile Ads SDK. It utilizes the [Google Mobile Ads Flutter plugin](https://pub.dev/packages/google_mobile_ads) to achieve 4 different kinds of Ads: [interstitial and rewarded ads](https://github.com/flutter/news_template/blob/main/google_news_project/lib/ads/bloc/full_screen_ads_bloc.dart#L28), [banner ads](https://github.com/flutter/news_template/blob/main/google_news_project/packages/news_blocks_ui/lib/src/widgets/banner_ad_content.dart#L48) and [sticky ads](https://github.com/flutter/news_template/blob/main/google_news_project/lib/ads/widgets/sticky_ad.dart#L10).

To configure ads, [create an AdMob account](https://support.google.com/admob/answer/7356219?visit_id=637958065830347515-2588184234&rd=1) and then [register an Android and iOS app](https://support.google.com/admob/answer/9989980?visit_id=637958065834244686-2895946834&rd=1) for each flavor of your application (e.g. 4 apps should be registered for development and production flavors). Make sure to provide correct AdMob app ids when generating the application from the template.

For details about AdMob Ad types and usage visit [Google AdMob quick-start page](https://developers.google.com/admob/flutter/quick-start).

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

## Push Notifications

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

## Newsletter

The current [implementation](https://github.com/flutter/news_template/blob/main/api/lib/src/api/v1/newsletter/create_subscription/create_subscription.dart) of newsletter email subscription will always return true and the response is handled in the app as a success state. Be aware that the current implementation of this feature does not store the subscriber state for a user.

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

## Subscriptions and purchases

This project supports in-app purchasing for Flutter using the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package. For the purpose of this template application, a mocked version of the`in_app_purchase` package was created called [purchase_client](https://github.com/flutter/news_template/tree/main/google_news_project/packages/purchase_client).

The [PurchaseClient class](https://github.com/flutter/news_template/tree/main/google_news_project/packages/purchase_client/lib/src/purchase_client.dart#L36) implements `InAppPurchase` from the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package and utilizes the same mechanism to expose the `purchaseStream`.

```
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => _purchaseStream.stream;
```

Mocked products are being exposed in the [products.dart](https://github.com/flutter/news_template/tree/main/google_news_project/packages/purchase_client/lib/src/products.dart) file.

A list of availiable subscription data featuring copy text and price information is served by Dart Frog backend. To edit the subscription data, change the `getSubscriptions()` method in your custom news data source. Make sure that the product IDs are the same for your iOS and Android purchase project, as this information will be passed to the platform-agnostic `in_app_purchase` package.

### in_app_purchase usage

To use the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package, substitute `PurchaseClient` usage in [main_development.dart](https://github.com/flutter/news_template/tree/main/google_news_project/lib/main/main_development.dart#L80) and [main_production.dart](https://github.com/flutter/news_template/tree/main/google_news_project/lib/main/main_production.dart#L80) with the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package implementation.

Then, follow the [Getting started](https://pub.dev/packages/in_app_purchase#getting-started) paragraph in the [in_app_purchase](https://pub.dev/packages/in_app_purchase) package.

## Removing Advertisements

You may want to remove advertisements from your app. This section discusses how to remove the various advertisement types and their dependencies.

### Removing Banner Ads

The `static_news_data.dart` file which your app displays contains banner ads by default. As you [implement your data source](#implementing-an-api-data-source),  do not insert `AdBlocks` into the data returned from your data source and your app will not display `BannerAds`.

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

*Ad Source Code*

Remove the following directories and files entirely:

- `google_news_project/lib/ads`
- `google_news_project/test/ads`
- `google_news_project/packages/ads_consent_client`
- `google_news_project/packages/news_blocks_ui/lib/src/widgets/banner_ad_content.dart`
- `google_news_project/packages/news_blocks_ui/test/src/widgets/banner_ad_content_test.dart`
- `google_news_project/packages/news_blocks_ui/lib/src/banner_ad.dart`
- `google_news_project/packages/news_blocks_ui/test/src/banner_ad_test.dart`

Remove the noted snippets from the files below:

- `google_news_project/lib/app/view/app.dart`
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

- `google_news_project/lib/article/view/article_page.dart`
    - `HasWatchedRewardedAdListener` class
    - `HasWatchedRewardedAdListener` widget (retain the child `Scaffold` widget)
- `google_news_project/lib/main/main_development.dart`
    ```dart
    final adsConsentClient = AdsConsentClient();
    ```
    ```dart
    adsConsentClient: adsConsentClient,
    ```
 - `google_news_project/lib/main/main_production.dart`
    ```dart
    final adsConsentClient = AdsConsentClient();
    ```
    ```dart
    adsConsentClient: adsConsentClient,
    ```
- `google_news_project/lib/onboarding/bloc/onboarding_bloc.dart`
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
- `google_news_project/lib/onboarding/view/onboarding_page.dart`
    ```dart
    adsConsentClient: context.read<AdsConsentClient>(),
    ```
- `google_news_project/lib/article/widgets/article_content_item.dart`
    ```dart
    else if (newsBlock is BannerAdBlock) {
      return BannerAd(
        block: newsBlock,
        adFailedToLoadTitle: context.l10n.adLoadFailure,
      );
    }
    ```
- `google_news_project/lib/article/widgets/article_content_item.dart`
    ```dart
    else if (newsBlock is BannerAdBlock) {
      return BannerAd(
        block: newsBlock,
        adFailedToLoadTitle: context.l10n.adLoadFailure,
      );
    }
    ```
- `google_news_project/packages/news_blocks_ui/lib/news_blocks_ui.dart`
    ```dart
    export 'src/banner_ad.dart' show BannerAd;
    ```
- `google_news_project/packages/news_blocks_ui/lib/src/widgets/widges.dart`
    ```dart
    export 'banner_ad_content.dart';
    ```

*Pubspec Ad Depenedencies*

Remove the `google_mobile_ads` dependency from the `google_news_project/packages/news_blocks_ui/pubspec.yaml` file, as well as all corresponding
```dart
import  'package:google_mobile_ads/google_mobile_ads.dart'
```
statements.

Remove the `ads_consent_client` dependency from `google_news_project/pubspec.yaml`, as well as all `ads_consent_client` and all `ads` import statements:
```dart
import 'package:ads_consent_client/ads_consent_client.dart';
import 'package:google_news_template/ads/ads.dart';
```

