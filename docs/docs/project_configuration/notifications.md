---
sidebar_position: 5
description: Learn how to configure notifications for your application.
---

# Notifications Setup

The Flutter News Toolkit comes with [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) set up, but your application is equally compatible with [OneSignal](https://onesignal.com/) as a push notification solution.

This section discusses how to integrate your notifications service infromation into your app. For information on using FCM or OneSignal within your code after following the steps here, please refer to the [Push Notifications](/flutter_development/push_notifications.md) section.

## FCM

[Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) (FCM) is a cross-platform messaging solution that lets you reliably send messages at no cost. A newly-generated Flutter News Toolkit application comes with Firebase Cloud Messaging already installed. In order to customize your app messaging you will need to first create a [Firebase project](https://firebase.google.com/docs/android/setup#create-firebase-project) and register your app flavors for [iOS](https://firebase.google.com/docs/ios/setup#register-app) and [Android](https://firebase.google.com/docs/android/setup#register-app) within the Firebase project.

You then need to specify your Firebase configuration for [iOS](https://firebase.google.com/docs/ios/setup#add-config-file) and [Android](https://firebase.google.com/docs/android/setup). Download the `google-services.json` file from Firebase for each of your flavors and replace the project's placeholder `google-services.json` files with your newly downloaded versions. Repeat this process with the `GoogleService-Info.plist` file to specify a Firebase configuration for your iOS flavors.

## OneSignal

[OneSignal](https://onesignal.com/) is a free notification service for your app that can be used in lieu of FCM. In order to use OneSignal as a notification solution, [create a OneSignal account and note your OneSignal app ID](https://documentation.onesignal.com/docs/flutter-sdk-setup). Then follow the [OneSignal SDK setup instructions](/flutter_development/push_notifications#onesignal).