---
sidebar_position: 3
description: Learn how to configure social login with Facebook and Twitter.
---

# Authentication Setup

The Flutter News Toolkit comes pre-configured to support passwordless email, Google, Apple and social authentication via Facebook and Twitter login. To set this up for your news app, follow the instructions below for each Firebase project and app.

## Email

### Firebase Configuration
In your Firebase Console, go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Email/Password` to set up your email authentication method. The toolkit currently supports a passwordless login flow, so be sure to enable this setting as well. 

:::note

Passwordless authentication with email link requires additional configuration steps. Please follow the steps for [Apple](https://firebase.google.com/docs/auth/ios/email-link-auth?authuser=0&hl=en) and [Android](https://firebase.google.com/docs/auth/android/email-link-auth?authuser=0&hl=en) configurations.

## Google

### Firebase Configuration
In your Firebase Console, go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Google` to set up your Google authentication method. Add your web ID and web client secret under the Web SDK Configuration dropdown menu. You can find your web client ID for existing projects by selecting your project and OAuth 2.0 entry on the [Google API Console](https://console.developers.google.com/apis/credentials?pli=1&project=hespress-en&authuser=0&hl=en).

## Apple

### Firebase Configuration
In your Firebase Console, go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Apple` to set up your Apple authentication method. Follow the additional configuration steps for [Apple](https://firebase.google.com/docs/auth/ios/apple?authuser=0&hl=en) and [Android](https://firebase.google.com/docs/auth/android/apple?authuser=0&hl=en) to enable this in your app. 

### Complete the Setup
To complete set up, add this authorization callback URL to your app configuration in the Apple Developer Console. Additional steps may be needed to verify ownership of this web domain to Apple. Follow [this link](https://firebase.google.com/docs/auth/?authuser=0&hl=en) to learn more.

## Facebook

### Create an App

Log in or create an account in the [Facebook Developer Portal](https://developers.facebook.com/apps/) to get started. Once logged in, create a new app to support your development project. In the same portal, enable the Facebook Login product (`Products -> Facebook Login`). Next, go to `Roles -> Roles` and add your developer team so the team can customize the app configuration for Android and iOS. Finally, go to `Settings -> Advanced` and enable "App authentication, native or desktop app?"

### Firebase Configuration

After setting up your [Firebase project](https://flutter.github.io/news_toolkit/project_configuration/firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Facebook` to set up your Facebook authentication method. Fill in the app ID and secret from the created Facebook app.

### Complete the Setup

To complete your setup, you'll need to add the OAuth redirect URI listed in your Firebase Authentication Sign-in Method to your Facebook app configuration. Follow [this link](https://firebase.google.com/docs/auth/?authuser=0&hl=en) for additional details.

## Twitter

### Create an App

Log in or create an account in the [Twitter Developer Portal](https://developer.twitter.com/). Once logged in, create both a project and an app to enable Twitter authentication in your news app. Enable OAuth 2.0 authentication by setting "yourapp://" as the callback URI and "Native app" as the type of the app. If possible, add your full team as developers of the Twitter app, so everyone has access to the app's ID and secret.

### Enable Elevated Access

Within [Twitter products](https://developer.twitter.com/en/portal/products), be sure to have the Twitter API v2 enable with "Elevated" access. This is needed for Twitter authentication to work.

:::note

You may need to fill out a form to apply for "Elevated" access.

:::

### Firebase Configuration

After setting up your [Firebase project](https://flutter.github.io/news_toolkit/project_configuration/firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter` to set up your Twitter authentication method. Fill in the app ID and secret from the created Twitter app.

### Complete the Setup

To complete your setup, you'll need to add the OAuth redirect URI listed in your Firebase Authentication Sign-in Method to your Twitter app configuration. Follow [this link](https://firebase.google.com/docs/auth/?authuser=0&hl=en) for additional details.
