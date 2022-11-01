---
sidebar_position: 3
description: Learn how to configure social login with Facebook and Twitter.
---

# Social Authentication Setup

The Flutter News Toolkit comes pre-configured to support social authentication via Facebook and Twitter login. To set this up for your news app, follow the instructions below.

## Facebook

### Create an App

Log in or create an account in the [Facebook Developer Portal](https://developers.facebook.com/apps/) to get started. Once logged in, create a new app to support your development project. In the same portal, enable the Facebook Login product (`Products -> Facebook Login`). Next, go to 'Roles -> Roles' and add your developer team so the team can customize the app configuration for Android and iOS. Finally, go to 'Settings -> Advanced' and enable "App authentication, native or desktop app?"

### Link App to Firebase

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

### Link App to Firebase

After setting up your [Firebase project](https://flutter.github.io/news_toolkit/project_configuration/firebase), go to `Firebase -> Authentication -> Sign-in-method -> Add new provider -> Twitter` to set up your Twitter authentication method. Fill in the app ID and secret from the created Twitter app.

### Complete the Setup

To complete your setup, you'll need to add the OAuth redirect URI listed in your Firebase Authentication Sign-in Method to your Twitter app configuration. Follow [this link](https://firebase.google.com/docs/auth/?authuser=0&hl=en) for additional details.
