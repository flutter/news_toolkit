---
sidebar_position: 3
description: Learn how to configure social login with Facebook and Twitter.
---

# Authentication setup

The Flutter News Toolkit comes pre-configured to support authentication using passwordless email, Google login, Apple ID, and social authentication using Facebook and Twitter login. To set this up for your news app, use the following instructions for each Firebase project and app.

## Email

The news toolkit supports passwordless login. This means a deep link is sent to the user's email address, that when clicked will open your app and log the user in.

### Firebase configuration

In your Firebase Console, go to **Firebase -> Authentication -> Sign-in-method -> Add new provider -> Email/Password** to set up your email authentication method. The toolkit currently supports a passwordless login flow, **so be sure to enable this setting as well**.

:::note

Passwordless authentication with an email link requires additional configuration steps. Please follow the steps for [authentication on Apple platforms](https://firebase.google.com/docs/auth/ios/email-link-auth?authuser=0) and [authentication on Android](https://firebase.google.com/docs/auth/android/email-link-auth?authuser=0) configurations.

:::

Once the email authentication method is set up, go to **Firebase -> Engage -> Dynamic links**. Set up a new dynamic link URL prefix (for example, yourApplicationName.page.link) with a dynamic link URL of "/email_login".

Once the dynamic link is set up, replace the placeholder value for **FLAVOR_DEEP_LINK_DOMAIN** inside the `launch.json` file with the **dynamic link URL prefix** you just created. This enviroment variable will be used inside `firebase_authentication_client.dart` to generate the dynamic link URL that will be sent to the user.

In addition, replace the placeholder value for every **FLAVOR_DEEP_LINK_DOMAIN** key within your `project.pbxproj` file with the dynamic link URL prefix you just created.

## Google

### Firebase configuration

In your Firebase Console, go to **Firebase -> Authentication -> Sign-in-method -> Add new provider -> Google** to set up your Google authentication method. Add your (Google) web ID and web client secret under the **Web SDK Configuration** dropdown menu. You can find your web client ID for existing projects by selecting your project and OAuth 2.0 entry on the [Google API Console](https://console.cloud.google.com/apis/credentials).

## Apple

### Firebase configuration

In your Firebase Console, go to **Firebase -> Authentication -> Sign-in-method -> Add new provider -> Apple** to set up your Apple authentication method. Enable this in your app by following the additional configuration steps for [Apple authentication](https://firebase.google.com/docs/auth/ios/apple?authuser=0) and [Apple authentication on Android](https://firebase.google.com/docs/auth/android/apple?authuser=0).

### Complete the setup

To complete setup, add this authorization callback URL to your app configuration in the Apple Developer Console. Additional steps might be needed to verify ownership of this web domain to Apple. To learn more, check out the [Firebase authentication](https://firebase.google.com/docs/auth/?authuser=0) page.

## Facebook

### Create an app

Log in or create an account in the [Facebook Developer Portal](https://developers.facebook.com/apps/) to get started. Once logged in, create a new app to support your development project. In the same portal, enable the Facebook Login product (**Products -> Facebook Login**). Next, go to **Roles -> Roles** and add your developer team so the team can customize the app configuration for Android and iOS. Finally, go to **Settings -> Advanced** and enable **App authentication, native or desktop app?**

### Firebase configuration

After setting up your [Firebase project](https://flutter.github.io/news_toolkit/project_configuration/firebase), go to **Firebase -> Authentication -> Sign-in-method -> Add new provider -> Facebook** to set up your Facebook authentication method. Fill in the app ID and secret from the created Facebook app.

### Complete the setup

To complete your setup, add the OAuth redirect URI listed in your **Firebase Authentication Sign-in Method** to your Facebook app configuration.

In addition, replace the placeholder value for every **FACEBOOK_APP_ID** , **FACEBOOK_CLIENT_TOKEN** and **FACEBOOK_DISPLAY_NAME** keys within your `project.pbxproj` file with their corresponding values.

For additional details, check out the [Firebase authentication](https://firebase.google.com/docs/auth/?authuser=0) page.

## Twitter

### Create an app

Log in or create an account in the [Twitter Developer Portal](https://developer.twitter.com/). Once logged in, create both a project and an app to enable Twitter authentication in your news app. Enable OAuth 2.0 authentication by setting "yourapp://" as the callback URI and "Native app" as the type of the app. If possible, add your full team as developers of the Twitter app, so everyone has access to the app's ID and secret.

### Enable elevated access

Within [Twitter products](https://developer.twitter.com/en/portal/products), be sure to enable Twitter API v2 with "Elevated" access. Twitter needs this for authentication to work.

:::note

You might need to fill out a form to apply for "Elevated" access.

:::

### Firebase configuration

After setting up your [Firebase project](https://flutter.github.io/news_toolkit/project_configuration/firebase), go to **Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter** to set up your Twitter authentication method. Fill in the app ID and secret from the created Twitter app.

### Complete the setup

To complete your setup, add the OAuth redirect URI listed in your **Firebase Authentication Sign-in Method** to your Twitter app configuration.

In addition, replace the placeholder values for **TWITTER_API_KEY** and **TWITTER_API_SECRET** inside the `launch.json` file. You must also replace the placeholder value for every **TWITTER_REDIRECT_URI_SCHEME** key within your `project.pbxproj` file with their corresponding values.

For more information, check out the [Firebase authentication](https://firebase.google.com/docs/auth/?authuser=0) page.
