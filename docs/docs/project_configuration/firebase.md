---
sidebar_position: 2
description: Learn how to configure your Firebase project.
---

# Firebase Setup

You need to specify Firebase configuration information for your app flavors and platforms. Please follow the instructions below to create your own Firebase projects and configure your apps.

:::note

Although the Flutter News Toolkit is pre-configured to work with Firebase, you're welcome to customize your codebase to leverage other services in your project.

:::

It is recommended to define at least two application environments: development and production. Each environment defines a different configuration of deep links, ads, and authentication along with a different entry point to the application (e.g. `main_development.dart`).

By default, your codebase should have support a production and development flavor. However, it's possible that you chose to create additional flavors when generating your project from mason.

In the [Firebase Console](https://console.firebase.google.com/u/0/), configure separate Firebase projects for each flavor that your project supports (e.g. development and production). This can also be done using the [firebase-tools CLI](https://github.com/firebase/firebase-tools) and the `firebase projects:create` command. In each Firebase project, create an Android and iOS app with appropriate package names. Make sure that development apps include the "dev" suffix. You may also do this using the `firebase apps:create` command.

Once configured, go to each Firebase project's settings and export the Google Services file for all apps. In the generated template, replace the content of all generated Google Services (`google-services.json` and `GoogleServiceInfo.plist`) using exported configurations.
