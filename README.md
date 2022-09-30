# Google News Template

The Google Flutter team and Google News initiative have co-sponsored the development of a news application template. Our goal is to help news publishers to build apps and monetize more easily than ever.

This template aims to **reduce typical news app development time by 80%.**

The Flutter news app template:
-   contains common news app UI workflows and core features built in Flutter and Firebase
-   implements best practices for news apps based on [Google News Initiative research](https://newsinitiative.withgoogle.com/info/assets/static/docs/nci/nci-playbook-en.pdf)
-   allows publishers to monetize immediately with pre-built Google Ads and subscription services

To preview the [available features](##available-features) in this app, run the example app using this template in the [Google News Project](https://github.com/flutter/news_template/blob/main/google_news_project/README.md) folder by following the setup steps in the project's README.

## Google News Mason Template

[Google News Template](https://github.com/flutter/news_template/blob/main/google_news_template/README.md) is a [mason](https://pub.dev/packages/mason) template generated from google_news_project.

## Google News Project

[Google News Project](https://github.com/flutter/news_template/blob/main/google_news_project/README.md) is a news application template built as a Flutter app with a [dart_frog](https://pub.dev/packages/dart_frog) backend.

## Available Features

The Google News Template was crafted to support a variety of news-oriented features. This feature list and product design was generated from real publisher feedback and direction. Although this list is not all-encompassing, it offers a feature-rich starting point for your own unique news application:

 - Ready-to-go core services (e.g. Firebase, [Google Analytics](TODO), Google Ads, FCM or OneSignal, Cloud Run, etc. )
 - [User Authentication](TODO) (Apple/Google/Email/Facebook/Twitter)
 - [Push Notifications](TODO) (FCM or OneSignal)
 - App Tracking
 - Content Feed
 - Article Pages
 - In-Line Images
 - Image Slideshow
 - Video Player
 - Search
 - [Subscription & Purchases](TODO)
 - Newsletter Subscription
 - [Ads](TODO) (banner ads, interstitial ads, sticky ads, rewarded ads)
 - Commenting UI
 - Pull to Refresh

## Getting Started

Below is an example project roadmap that can be leveraged to implement this template for your very own Flutter application. Please use this as a guide for your development efforts and deviate where necessary.

### Configuration

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
		 - Application suffix (appended to the application 			bundle identifier for a given flavor)
		 - Deep link domain (used to navigate from the app from email login link, configured from the Firebase Console)
		 - Twitter configuration (API key and API secret; used to login with Twitter)
		 - Facebook configuration (App ID, client token and display name; used to login with Facebook)
		 - Google Ad Manager or Admob configuration (App ID for iOS and Android; used to display ads) 

### Theming & Branding

- Update your app's [splash screen](#updating-the-app-splash-screen).
- Update your app's [launcher icons](#updating-the-app-launcher-icon).
-- If you'd like to support [adaptive ions for Android](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive), ensure you have background and foreground assets. 
- Update the [app logo in the top navigation bar](TODO).
- Update the app's [color palette](TODO) via the app's theme and [in-line color references](TODO).
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

 - You'll also want to [implement push notifications](TODO) using either FCM or OneSignal and update the UI to support the categories of notifications that you'd like to enable. 
 - Finally, [make any adjustments to the ads logic](#updating-ads-placement) to match your organization's requirements.

### API Deployment & Versioning

- After ensuring your dev and production api have been successfully [deployed on Cloud Run](TODO), you'll want to [release a new build version to your app stores](TODO).

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

-  Create repository within the ‘Github Organization’ to enable:
	- 	Branch protection rules defined the [README](https://github.com/flutter/news_template/blob/main/google_news_template/README.md#recommended-github-branch-protection-rules)
	- [Slack Integration](https://github.com/integrations/slack/blob/master/README.md) (recommended)
	- [Auto-deletion](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches) and [auto-merge](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-auto-merge-for-pull-requests-in-your-repository) for branches
	- Draft PRs
-  Grant Admin access to at least one developer to enable secrets creation.

### Facebook Authentication:

-  Create an app in the [Facebook developer portal](https://developers.facebook.com/apps/).
- In the same portal, enable the Facebook Login product (`Products -> Facebook Login`).
- Go to `Roles -> Roles` and add your developer team so the team can customize the app configuration for Android and iOS.
- In Facebook, go to `Settings -> Advanced` and enable "App authentication, Native or desktop app?"
-  After setting up your [Firebase project](TODO), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Facebook` to set up Facebook authentication method. Fill in the app ID and secret from the created Facebook app and share these secrets with your developer team.
- Use "OAuth redirect URI" from Firebase to set "Valid Oauth Redirect URIs" in the Facebook portal.

### Twitter Authentication:

- Create a project and app in the [Twitter developer portal](https://developer.twitter.com/) - both can have the same name like "Google News Template". Save the API key and secret when creating an app and share these secrets with your developer team.
- Enable OAuth 2.0 authentication by setting "yourapp://" as the callback URI and "Native app" as the type of the app.
- In [Twitter products](https://developer.twitter.com/en/portal/products), make sure to have the Twitter API v2 enabled with "Elevated" access - otherwise Twitter authentication is not going to work. 
	- You may need to fill out a form to apply for “Elevated” access.
- If possible, add your full team as developers of the Twitter app.
- After setting up your [Firebase project](TODO), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter` to set up Twitter authentication method. Fill in the app ID and secret from the created Twitter app and share these secrets with your developer team.

### [Firebase](https://github.com/flutter/news_template/blob/main/google_news_template/README.md#recommended-firebase-configuration):

- It is recommended to define at least two application environments: development and production. Each environment defines a different configuration of deep links, ads and authentication along with a different entry point to the application (e.g.  `main_development.dart`).

- When generating the template, choose "development production" as a list of desired application flavors. Choose "dev" as the application suffix for the development flavor.

- In Firebase, configure two separate Firebase projects for the development and production flavor. You may do this  [from the Firebase console](https://console.firebase.google.com/u/0/)  or using the  [firebase-tools CLI tool](https://github.com/firebase/firebase-tools)  and the  `firebase projects:create`  command. In each Firebase project, create an Android and iOS app with appropriate package names. Make sure that development apps include the "dev" suffix. You may also do this using the  `firebase apps:create`  command.

- Once configured, go to each Firebase project's settings and export the Google Services file for all apps. In the generated template, replace the content of all generated Google Services using exported configurations. 
-  Ensure the developer team has admin access.
-  Note the app IDs for your developer team.
-  Set-up Firebase authentication for supported sign-in platforms (Apple/Google/Email/Facebook/Twitter/etc.):
	-   For email login, enable the Email/password sign-in provider in the Firebase Console of your project. In the same section, enable Email link sign-in method. On the dynamic links page, set up a new dynamic link URL prefix (e.g. yourApplicationName.page.link) with a dynamic link URL of "/email_login".
	-   For Google login, enable the Google sign-in provider in the Firebase Console of your project. You might need to generate a SHA1 key for use with Android.
	-   For Apple login,  [configure sign-in with Apple](https://firebase.google.com/docs/auth/ios/apple#configure-sign-in-with-apple)  in the Apple's developer portal and  [enable the Apple sign-in provider](https://firebase.google.com/docs/auth/ios/apple#enable-apple-as-a-sign-in-provider)  in the Firebase Console of your project.
	-   For Twitter login, register an app in the Twitter developer portal and enable the Twitter sign-in provider in the Firebase Console of your project.
	-   For Facebook login, register an app in the Facebook developer portal and enable the Facebook sign-in provider in the Firebase Console of your project.
    
### [Google Ad Manager](https://support.google.com/admanager/answer/1656921) or [Admob](https://support.google.com/admob/answer/7356431):

-  Create apps for each platform and flavor (4 apps total).
-  Link the apps to the appropriate Firebase project.
- Share the app IDs with your developer team.
    

### FCM or OneSignal:

-  Share the developer and production app IDs with the development team.
    

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
-  Encrypt the GPLAY_KEY in Codemagic .
- Set-up the [GoogleApiService account connection](https://docs.codemagic.io/knowledge-base/google-services-authentication/) in Codemagic.
    

### Google Cloud API Deployments:

 - Set-up a [Google Cloud   
   account](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
   to host your API.
  - Enable Billing.
- Set-up an [Github Action Service account](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions).
- Configure  [API authentication](https://cloud.google.com/docs/authentication#:~:text=the%20section%20below.-,Authentication%20strategies,public%20data%20using%20API%20keys.)
   and [user authentication for your   
   API](https://cloud.google.com/run/docs/authenticating/end-users#cicp-firebase-auth)
   (optional). 

### Google Play Store:

-   [Set up API access](https://play.google.com/console/u/0/developers/6749221870414263141/api-access)

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
