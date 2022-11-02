---
sidebar_position: 6
description: Learn how to setup your application for publishing to the app store.
---

# App Store Setup

Since Flutter allows you to build apps for multiple platforms, your project is compatible for both Android and iOS. Follow the steps below to create apps in both the Google Play Store and Apple App Store.

## Google Play Store

### Create Apps

To create your Android apps, you'll first need to create or log into an existing developer account in the [Google Play Console](https://play.google.com/console/developers). Under the `Users and permissions` tab, invite new users and grant appropriate permissions for your team. By default, you should generate a developer and production app for Android. If you chose to create additional flavors when generating your project from mason, create additional apps for each flavor.

### Configure App Information

Under the `Store presence` dropdown, select `Main store listing` to configure your app information. Populate the required fields under the `Store settings` menu as well. If you plan to offer a subscription package in your news app, [set up the subscription product](https://play.google.com/console/u/0/developers/6749221870414263141/app-list) under the `Products` dropdown in the `Subscriptions` menu item.

## Apple App Store

### Create Apps

To create your iOS apps, you'll first need to create or log into an existing developer account in the [Apple Developer Program](https://developer.apple.com/programs/enroll/). Log into your [App Store Connect](https://appstoreconnect.apple.com/login) account and select `Users and Access` to grant appropriate permissions to your team. Under `Apps`, create a developer and production app for your new project. If you chose to create additional flavors when generating your project from mason, create additional apps for each flavor.

### Configure App Information

Get started by populating the fields under the `App Information` menu for your app. Configure the Privacy Policy and Terms of Use (EULA) in the `App Privacy --> Privacy Policy` section. Create the first release of your app to be able to setup subscriptions, which is later done in the `In-App Purchases` and `Subscriptions` menus. Follow [this link](https://developer.apple.com/in-app-purchase/) for more information about in-app purchases and subscriptions.
