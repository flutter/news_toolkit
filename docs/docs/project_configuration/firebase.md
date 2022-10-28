---
sidebar_position: 2
description: Learn how to configure your Firebase project.
---

# Firebase Setup

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
