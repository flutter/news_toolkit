---
sidebar_position: 5
description: Learn how to configure notifications for your application.
---

# Notifications setup

The Flutter News Toolkit comes with [Firebase Cloud Messaging (FCM)](https://firebase.google.com/docs/cloud-messaging) set up, but you can also configure your application with [OneSignal](https://onesignal.com/) for push notifications.

For information on using FCM or OneSignal in your app, refer to the [Push notifications](/flutter_development/push_notifications.md) documentation section.

:::note
Notifications only appear when your app is running on a physical device.
:::

## FCM

[Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) (FCM) is a cross-platform messaging solution that lets you reliably send messages at no cost. A newly-generated Flutter News Toolkit application comes with Firebase Cloud Messaging already installed. To customize app messaging, you must first create a [Firebase project](https://firebase.google.com/docs/android/setup#create-firebase-project) and register your app flavors for [iOS](https://firebase.google.com/docs/ios/setup#register-app) and [Android](https://firebase.google.com/docs/android/setup#register-app) within the Firebase project.

Next, specify your Firebase configuration for [iOS](https://firebase.google.com/docs/ios/setup#add-config-file) and [Android](https://firebase.google.com/docs/android/setup). Download the `google-services.json` file from Firebase for each of your flavors and replace the project's placeholder `google-services.json` files with your newly downloaded versions. Repeat this process with the `GoogleService-Info.plist` file to specify a Firebase configuration for your iOS flavors.

## OneSignal

[OneSignal](https://onesignal.com/) is a free notification service for your app that you can use instead of FCM. To use OneSignal as a notification solution, [create a OneSignal account and note your OneSignal app ID](https://documentation.onesignal.com/docs/flutter-sdk-setup). Then follow the [OneSignal SDK setup instructions](/flutter_development/push_notifications#onesignal).
