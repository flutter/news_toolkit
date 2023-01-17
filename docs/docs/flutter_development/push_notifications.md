---
sidebar_position: 7
description: Learn how to configure push notifications in your Flutter news application.
---

# Push notifications

## Firebase Cloud Messaging (FCM)

This template comes with [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) pre-configured. If you prefer to [use OneSignal](https://flutter.github.io/news_toolkit/project_configuration/notifications/#onesignal) instead, use the instructions in the last section of this page.

Out of the box, the application subscribes to topics corresponding to supported news categories, such as `health`, `science`, `sports`, `food`, and so on.

### Triggering a notification 📬

Trigger a notification using the [Firebase Cloud Messaging REST API](https://firebase.google.com/docs/reference/fcm/rest): 

- First, generate a (required) access token in the [Google OAuth 2.0 Playground](https://developers.google.com/oauthplayground/).

- Select the `https://www.googleapis.com/auth/firebase.messaging` scope under **Firebase Cloud Messaging API v1** and click **Authorize APIs**.

- Then, sign in with the Google Account that has access to the respective Firebase project and click **Exchange authorization code for tokens**.

- To send a message to a topic, use the following `cURL` syntax:

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

:::note

> In the previous example, replace `<ACCESS_TOKEN>` with the access token generated from the Google OAuth 2.0 Playground, `<TOPIC-NAME>` with the desired topic name, and `<PROJECT-ID>` with the corresponding Firebase project ID.

:::

:::note

Ensure that you're running the application on a physical device in order to receive FCM messages.

:::

## OneSignal

Follow OneSignal's guide for [setting up the OneSignal Flutter SDK](https://documentation.onesignal.com/docs/flutter-sdk-setup). Make sure to:

- Ensure all requirements for integration listed in the OneSignal documentation are met.
- Add the OneSignal Flutter SDK dependency.
- Add an iOS service extension in Xcode.
- Enable `push capability` in Xcode.
- Setup OneSignal for Android in the codebase.
- Initialize OneSignal in the notifications client package.
- Replace FCM references in the codebase with the corresponding OneSignal infrastructure:
  - In `lib/main/bootstap/bootstrap.dart` replace `FirebaseMessaging` with `OneSignal` and the `FireBaseMessaging.instance` with a `OneSignal.shared` instance.
  - In the `main.dart` file for each of your flavors, assign `notificationsClient` to an instance of `OneSignalNotificationsClient`.
- Run the app and send test notifications through OneSignal.
  - _Note: iOS push notifications only work if tested on a physical device_.
